---
title: 'xhr과 fetch 차이에 대해 알고 있나요?'
tags: ['API', 'frontend', 'network']
date: '2024-01-24'
draft: false
summary: 'xhr과 fetch는 어떻게 스펙이 다를까?'
---

# 네트워크 탭에 type이라는 것이 있다?

![](https://velog.velcdn.com/images/mindev/post/ad2c4ebf-a006-44e5-817a-7fe7f63bf68e/image.png)

디버깅을 위해 네트워크 탭을 확인하다가 어떤 것은 `xhr`이고, 어떤 것은 `fetch`로 type이 나뉘어져 있다는 사실을 알게 됐습니다.

권한이 필요한 부분은 axios instance를 만들어서 사용하고 나머지 부분은 점진적으로 fetch api로 migration하고 있었는데, axios가 xhr로 동작한다는 사실을 처음 알게 됐습니다. (이래서 라이브러리를 쓰기 전에 어떻게 동작하는지 알아야 하는 것 같다고 생각했습니다)

라이브러리를 선택할때 어떻게 동작하는지 알지 못한 채 사용한 것 같아 지금이라도 바로 잡기 위해 어떤 차이점이 있는지 찾아보게 되었습니다.

## XHR

mdn에서는 xhr을 다음과 같이 소개합니다.

> XMLHttpRequest(XHR)은 AJAX 요청을 생성하는 JavaScript API입니다. XHR의 메서드로 브라우저와 서버간의 네트워크 요청을 전송할 수 있습니다.

오래되고 이름부터 `XML`이 들어가있어 마치 xml로 데이터 교환을 해야 할 것 같지만, 현재는 다앙햔 데이터 타입(json)을 지원합니다.

## fetch

mdn에서는 fetch를 다음과 같이 소개합니다.

> Fetch API는 네트워크 통신을 포함한 리소스 취득을 위한 인터페이스를 제공하며, XMLHttpRequest보다 강력하고 유연한 대체제입니다.

fetch는 xhr을 `대체하기 위해` 만들어졌고, 더 효과적으로 사용할 수 있도록 설계됐다고 안내하고 있습니다.

### 정확하게 어떤 점이 다를까?

#### 응답처리

XHR은 `콜백`을 받아서 responseText, responseXML 등을 통해 응답을 처리합니다.
fetch는 `promise`를 기반으로 동작하고 response.json(), response.text()를 사용합니다.

#### cors

XHR은 cors를 위한 추가 설정이 필요합니다.
fetch는 cors에 대한 기본 지원이 있어 간단하게 처리할 수 있습니다.

```js
fetch('https://api.example.com', {
  mode: 'cors',
  credentials: 'same-origin',
  headers: {
    'Content-Type': 'application/json',
  },
})
```

#### 파일 업로드 및 다운로드

xhr에서는 `progress 이벤트`를 통해 업로드 진행률 데이터를 받을 수 있습니다.
fetch에서는 `AbortController`를 사용해서 요청에 대한 추가 정보를 얻을 수 있습니다. (아직 실험적인 기능)

fetch에서는 form data를 보내기 위해 Content-Type에 `multipart/form-data`를 명시해줬는데, `boundary`를 위해 명시가 아닌 자동 설정 기능을 활용해야 한다는 것을 알게 됐었습니다. (반드시 명시할 필요가 없었습니다)

### 어떤 것을 사용해야할까?

XHR을 사용하는 것은 복잡하지만, axios instance를 사용하게 되면 개발 향상성이 눈에 띄게 올라가기 때문에 고려해볼 필요가 있을 것 같습니다. (추후 axios가 fetch 기반으로 변경될 수도 있습니다)

#### 지원하는 브라우저를 고민해야 한다.

xhr은 일단 구형 브라우저에서도 원활하게 지원됩니다.
fetch는 기본적으로 es6 이상을 지원하는 브라우저에서 동작합니다.
따라서, fetch를 구형 브라우저에서 동작하게 하려면 `폴리필`하는 과정을 거쳐야 하는데 fetch를 폴리필하면 xhr로 변환해서 사용하기도 합니다.

#### es6 이상이면 xhr을 사용할 이유가 있나요?

fetch는 애초에 xhr을 대체하기 위해 사용되므로 간단한 인터페이스 관리를 위해 fetch를 우선적으로 사용하도록 하는게 좋을 것 같습니다.
개인적으로 굳이 axios 같은 추가 모듈을 설치하여 코드에 의존성을 더 할 필요는 없다고 생각이 듭니다.
다만, `인터셉터`와 같은 기능을 구현하기에 fetch는 꽤나 복잡하므로 이런 경우에는 axios를 사용하는 것이 좋을 것 같습니다.

#### 추가로 알아두면 좋은 점

fetch를 사용하다보면 다음과 같은 패턴을 발견하게 됩니다.

```js
fetch(url)
	.then((response) => response.json())
	.then((data) => /*handle data..*/)
```

왜 fetch로 받아온 서버 응답을 response.json()을 통해 json으로 가공하여 사용해야 할까요?
일단 fetch는 promise를 2번 반환합니다.
fetch는 header를 먼저 받고 response를 반환합니다. (아직 body가 없는 상태, 추가로 axios는 헤더와 응답을 동시에 받아온다.)

만일, 대용량 데이터를 받는다고 가정하면 Chunk로 나누어서 데이터를 받는 것이 효율적이기 때문에 이렇게 구현됐습니다. (점유하지 않고 메모리를 나눠쓸 수 있음) 데이터를 나눠받다보니 사용자 경험도 향상시킬 수 있습니다.

### 참고하면 좋은 블로그 게시글

> https://batcave.tistory.com/63

xhr부터 fetch를 스스로 탐구하시면서 파악한 게시글이라 조금 더 자세히 알고 싶다면 읽기를 추천합니다.

> https://jeonghwan-kim.github.io/2023/12/27/fetch

김정환님께서 올리신 포스팅으로 fetch 함수가 왜 2번의 promise를 사용하는지에 대해 정리된 내용입니다.
