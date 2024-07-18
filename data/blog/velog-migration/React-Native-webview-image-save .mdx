---
title: 'React Native 웹뷰에서 이미지 저장하기 '
date: '2024-02-16'
tags: ['react native', 'webview']
draft: false
summary: '웹뷰에서 네이티브앱으로 이미지를 저장하는 방법'
---

# 웹에서 이미지 저장 기능이 있는 경우

![](https://velog.velcdn.com/images/mindev/post/a89309f0-81be-487c-9d17-ad8558704bc3/image.png)
[피어나](www.peerna.me)서비스를 개발하면서 웹에서 이미지를 저장해야 하는 기능이 필요했습니다. 하지만, 웹뷰앱으로 개발하다 보니 앱에서는 다운로드할 수 없는 문제가 생겼습니다.

## 해결 과정

시도에 앞서 제약조건은 다음과 같았습니다.

1. Webview 컴포넌트에서 동작이 이루어질 것
2. Webview의 postMessage와 onMessage로 동작할 것
3. AOS와 iOS에서 정상적으로 동작할 것

웹뷰 서비스이기 때문에 Webview 컴포넌트의 의존성을 벗어나기는 힘들었습니다.
React Native단에서 다운로드를 구현할 수 있었지만, 웹으로 개발하여 개발 생산성을 올리고자 했던 목표와 벗어났기 때문에 Web에서의 이벤트를 RN에서도 공유받기를 원했습니다.
그래서 웹에서의 구현을 앱에서도 동작할 수 있게 만들어야 했습니다.

### blob 방식

```tsx
// Web
fetch(FLOWER_CARD, { cache: 'no-cache' })
  .then((response) => response.blob())
  .then((blob) => {
    const href = window.URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = href
    link.download = FLOWER_CARD
    document.body.appendChild(link)
    link.click()
    document.body.removeChild(link)
    toast.success('이미지가 저장됐어요!')
  })
```

blob 링크를 만들어 이동시키면 이미지를 다운로드 받지 않을까?라는 생각에 초기에 웹도 blob방식으로 개발하였습니다.
일단 AOS, iOS 둘 다 blob 링크로 이동하여 다운로드가 동작하지 않았기 때문에 링크 자체로 이동하여 파일을 다운로드 받는 방식은 사용할 수 없었습니다.
따라서, blob 데이터를 FileReader로 읽어 Web -> App으로 전송하여 base64 문자열로 인코딩해서 전송하였습니다

### base64 문자열 media

```tsx
// Web
const reader = new FileReader()
reader.onloadend = () => {
  WebviewBridge.postMessage({
    type: 'card-image',
    data: reader.result,
  })
}
reader.readAsDataURL(blob)

// App Webview.onMessage
// iOS: success, AOS fail
await CameraRoll.saveAsset(base64Image)
```

base64 문자열을 이미지로 저장할 수 있는 라이브러리를 찾다보니 `@react-native-camera-roll/camera-roll`을 찾게 되었습니다.

iOS에서는 다른 변환과정없이 정말 쉽게 base64 문자열을 이미지로 저장할 수 있었습니다.
문제는 AOS에서 발생했는데, 버그의 원인을 좀처럼 잡을 수 없었습니다.

그렇게 Github 문서를 읽던 중 다음과 같은 글을 발견했습니다.
![](https://velog.velcdn.com/images/mindev/post/131a53df-448f-483d-aa04-5bb26e612f60/image.png)
원인은, android에서는 save 함수는 `file:///../file.[png]`형식으로 로컬 시스템에 있는 이미지를 저장할 수 있다는 것이었습니다.
그래서 base64를 `react-native-fs` 라이브러리를 통해 로컬 디렉토리에 저장하였고, 저장된 이미지를 CameraRoll 라이브러리를 통해 갤러리에 저장할 수 있게 구현하였습니다.

```tsx
// App Webview.onMessage
// AOS
const imageData = base64Image.split(';base64,').pop()
const filePath = `${RNFS.CachesDirectoryPath}/temp_image_${new Date().getTime()}.jpg`
await RNFS.writeFile(filePath, imageData!, 'base64')
await CameraRoll.saveAsset(`file://${filePath}`, { type: 'photo' })
// 이미지 저장 후 다시 로컬에서 지워준다.
await RNFS.unlink(filePath)
```

## 구현 중 주의사항

### @react-native-camera-roll/camera-roll 안드로이드 설정

React Native에서 linking이 되는 버전들의 경우에는(^RN0.69) 공식 문서의 설정을 하지 않아도 됩니다.
![](https://velog.velcdn.com/images/mindev/post/b4da9706-e1a3-47bd-a282-b6b3be2f1700/image.png)

### Android Permission

Android API >= 33인 경우, `READ_MEDIA_IMAGES, READ_MEDIA_VIDEO`를 요청하고
Android API < 33인 경우, `READ_EXTERNAL_STORAGE, WRITE_EXTERNAL_STORAGE`를 요청해야 합니다.

#### 추가로

웹뷰에서 userAgent에 따라 로직을 분기한 경우가 있는데, 개발자 도구 Dimensions을 iPhone이나 Android 기기로 바꾸면 userAgent도 함께 바뀌기 때문에 테스트하기 용이해집니다.
