## Information
- App Name: Budget
- Language: Flutter (3.22.0)
- Java: 17
- Description: Budget is app for manage your money. Base on from transacntions and the app not get information about Bank card and releated it. It help user can caculator expense every day, every week,...
## Document
- [flutter_facebook_auth](https://facebook.meedu.app/docs/4.x.x/intro)
## CI/CD
fastlane add_plugin increment_version_code
- Play_store:
    - Tracks:
        - production: Deploys to Production
        - beta: Deploys to Open testing
        - alpha: Deploys to Closed testing
        - internal: Deploys to Internal testing

## Command
- Check lint: 
    ```
    dart run custom_lint
    ```
    ```
    dart run build_runner watch -d
    ```
- Rebuild launch icon:
    ```
    flutter pub run flutter_launcher_icons
    ```
- Build abb:
    ```
    flutter build appbundle
    ```
### Chính sách quyền riêng tư
- [Chính sách](https://www.termsfeed.com/live/2d5f7165-d7ba-49b3-b191-6f3f94b412ac)
