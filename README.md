# Capture

## なにこれ

- Web サイトのキャプチャする
- 一応、クロールっぽい挙動もする

## 設定

```yaml
requests:
  - request:
      name: google
      uri: http://www.google.co.jp
  - request:
      name: yahoo
      uri: http://www.yahoo.co.jp  
   request:
      name: test
      uri: http://xxx.xxx.xxx.xxx:10080/auth-basic/
      auth:
        user: test
        pass: test
  - request:
      name: test-foo
      uri: http://xxx.xxx.xxx.xxx:10080/auth-basic/foo.html

image:
  dir:
    original: ./original/
    cropped: ./cropped/
  name:
    prefix: foo_
  size:
    height: 800
    width: 600
  extension: .png
```
