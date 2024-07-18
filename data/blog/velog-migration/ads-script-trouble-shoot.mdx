---
title: '프론트엔드 개발자는 어떻게 삽질을 할까(광고 스크립트 트러블슈팅 과정)'
date: '2024-01-19'
tags: ['React', 'html', 'web']
draft: false
summary: '프론트엔드 개발자는 외부 라이브러리를 쓰면 삽질을 하게 됩니다.'
---

> 스크립트와 관련해서 트러블슈팅 이야기를 그냥 작성하는 게시글입니다. 재미로 읽어주세요.

# 외부 스크립트의 동작에 문제가 발생했다

현재 우리 서비스에서는 인도네시아에서 사용되기 때문에, 인도네시아 플랫폼의 광고 스크립트를 index.html에 추가하여 사용하고 있었습니다.

```html
<!-- index.html -->
...
<head>
  <script async="async" data-cfasync="false" src="ads.com/[hashed-data]/invoke.js"></script>
</head>
```

광고는 invoke.js에서 element id가 `"container-[hashed-data]"`를 만나면 광고 api를 호출하여 해당 container의 자식으로 추가해주는 방식이었습니다.

하지만, 광고를 조회하고 다시 conatainer를 만날 때에는 광고 api를 호출해주지 않는 문제가 있었습니다. (단 한 번만 실행되는 방식으로 구현됐던 것 같습니다. spa에서만 생기는 문제였던 것 같습니다.)

## 시도한 방법

### head 태그에서 삭제 후 다시 로딩해보자

다시 스크립트를 로딩하면 덮어씌우지 않을까?라는 생각에 시도한 방법이었습니다

```tsx
useEffect(() => {
  const scriptTag = document.head.getElementById('script-id')
  if (scriptTag) scriptTag.parentNode.removeChild(scriptTag)

  const newScript = document.createElement('script')
  newScript.src = 'ads.com/[hashed-data]/invoke.js'
  newScript.async = true
  newScript.setAttribute('data-cfasync', 'false')

  // 새로운 스크립트를 <head>에 추가
  document.head.appendChild(newScript)
  return () => {
    if (newScript.parentNode) newScript.parentNode.removeChild(newScript)
  }
}, [])
```

결과는 실패였습니다. 브라우저가 이미 invoke.js를 저장하고 있으므로, 결국 다시 다운로드하지 않았습니다.

### 그렇다면 캐시 무효화를 써보자

스크립트 태그를 다르게 해서 다운로드하면 다르지 않을까?해서 랜덤 난수를 집어 넣었습니다.

```tsx
useEffect(() => {
  const scriptTag = document.head.getElementById('script-id')
  if (scriptTag) scriptTag.parentNode.removeChild(scriptTag)

  const randomNumber = Math.floor(Math.random() * 1000000)
  const newScript = document.createElement('script')
  newScript.src = `ads.com/[hashed-data]/invoke.js?v=${randomNumber}`
  newScript.async = true
  newScript.setAttribute('data-cfasync', 'false')

  // 새로운 스크립트를 <head>에 추가
  document.head.appendChild(newScript)
  return () => {
    if (newScript.parentNode) newScript.parentNode.removeChild(newScript)
  }
}, [])
```

새로운 파일들이 다운로드 되기는 했지만, 역시나 동작하지 않았습니다.
아마 브라우저가 이미 다운로드한 스크립트를 사용하고 있기 때문에 새로 다운로드 받아도 동작하지 않는 것 같습니다. (스코프 문제인 것 같습니다.)

### Function 객체로 직접 함수를 실행해보자

스크립트를 다운받지말고 response로 text를 응답 받은 다음 직접 핸들링할 수 있게 Function 객체에 주입을 해서 필요할 때 사용한다면 해결되지 않을까? 해서 시도해 보았었습니다.

```tsx
const reloadAdScript = () => {
  const scriptUrl = `ads.com/[hashed-data]/invoke.js`

  // fetch를 사용하여 스크립트 가져오기
  fetch(scriptUrl)
    .then((response) => response.text())
    .then((scriptCode) => {
      // Function 생성자를 사용하여 코드를 실행
      const scriptFunction = new Function(scriptCode)
      scriptFunction()
    })
}

reloadAdScript()
```

역시나 첫 로딩 이후에는 동작하지 않았습니다. (애초에 함수 호출로 해결되는 문제가 아니었던 것 같습니다.)

## 다시 문제로 돌아가서

근본적인 문제는 광고 스크립트가 첫 로딩 이후 동작하지 않는다는 문제였습니다.
그래서 일단 광고 스크립트가 어떻게 생겼는지 직접 Source탭에서 열어서 확인했습니다.

```js
function _0x3db0(_0x14c735, _0x4acdc2) {
    _0x14c735 = _0x14c735 - 0xef;
    var _0x2d860a = _0x2d86[_0x14c735];
    return _0x2d860a;
}
(function(_0x2d7c33, _0x5e9d09) {
    var _0xc45544 = _0x3db0;
    while (!![]) {
        try {
            if (_0x1312a4 === _0x5e9d09)
                break;
            else
                _0x2d7c33['push'](_0x2d7c33['shift']());
        } catch (_0x4e3ed3) {
            _0x2d7c33['push'](_0x2d7c33['shift']());
        }
    }
}(_0x2d86, 0xae266),
!function() {
    'use strict';
    var _0x1df4be = _0x3db0;
    var _0x2c6098 = _0x315f48(), _0x2dff1f, _0x34b13b = !0x1, _0x319e0c = !0x0, _0x26db36 = !0x1, _0x2654df = _0x1df4be(0x149), _0x3771fd = _0x1df4be(0x159), _0x90733b = [[/%26/g, '&'], [/%20/g, '\x20'], [/%2B/g, '+'], [/%25/g, '%'], [/%3E/g, '>'], [/%3C/g, '<'], [/%2F/g, '/'], [/%3A/g, ':'], [/%3B/g, ';']], _0x49922b = function() {

    }
```

빌드과정에서 난독화를 해놔서 알아볼 수 없었지만, api나 함수의 문자열은 그대로 저장돼있어서 힌트를 얻을 수 있었습니다.
![](https://velog.velcdn.com/images/mindev/post/9cb77e5c-bb05-4f48-a1b7-6c18b87e2b19/image.png)

이미지를 보면 reload에 대한 코드가 있었고 관련해서 광고 플랫폼 개발자에게 문의해보니, container element에 해당 함수가 할당이 되고 초기화할 수 있다는 이야기를 들었습니다.
시도해본 결과 처음 조우했을 때만 할당이 되는 것을 확인할 수 있었습니다.

그렇다면 `처음 할당될 때 전역 함수에 다시 재할당을 해서 사용할 수 있지 않을까?` 라는 생각으로 마지막 시도를 했습니다.

### 마지막으로 시도한 reload 함수를 전역에 저장하기

```tsx
useEffect(() => {
  const targetDiv = document.getElementById('container-[hashed-data]')

  if (targetDiv && targetDiv.reload) {
    document.globalFunction = document.globalFunction || {}
    document.globalFunction.reload = targetDiv.reload
  }

  if (document.globalFunction.reload) {
    document.globalFunction.reload()
  }
}, [])
```

![](https://velog.velcdn.com/images/mindev/post/90134c2e-2ffe-4354-bd0b-ffe2485e5fe7/image.png)

> 감격스러운 성공의 순간이다.

window 객체에 해당 함수가 저장돼서 출력됐습니다. 또한, 정상적으로 실행되어 이제 다시 container를 조우해도 광고가 제대로 나오게 됐습니다.

#### 추가로

- 난독화된 함수 이름이 항상 일정하다면 직접 호출해서도 사용할 수 있을 것 같았습니다. 하지만, 언젠가 새 버전의 빌드가 되고, 해싱된다면 함수명의 일치를 보장할 수 없으니 element에 직접 할당해주는 함수를 복사하는 것이 안정성면에서 더 나은 것 같습니다.

나름 재밌는 트러블 슈팅 과정(삽질) 이었습니다. 외부 script를 Source 탭에서 확인해서 전역에 등록돼있다면 직접 호출할 수 있다는 것과(어차피 스코프에 등록되기 때문에), 난독화된 소스에서 직접 데이터를 찾아 헤매는 과정도 성장의 포인트인 것 같았습니다.
