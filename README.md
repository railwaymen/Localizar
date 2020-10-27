# Localizar

Web app for localizing mobile/web apps.

## Technologies:

<a href="https://swift.org"><img src="https://skoogmusic.com/wp-content/uploads/2017/02/Swift.org-icon-440x440.png" alt="Swift" height="100"></a>
<a href="https://vapor.codes"><img src="https://avatars0.githubusercontent.com/u/17364220?s=280&v=4" alt="Vapor" height="100"></a>
<a href="https://vuejs.org"><img src="https://vuejs.org/images/logo.png" alt="Vue.js" height="100"></a>

## Contribution

### Requirements

- [Swift 5.3](https://swift.org/getting-started/#installing-swift)
- [Swift Version Manager 1.4.0](https://swiftenv.fuller.li/en/latest/installation.html)
- [Yarn 1.22.10](https://classic.yarnpkg.com/en/docs/install)

### Installation

1. Install yarn dependencies
    ```
    yarn install
    ```
2. Create the PostgreSQL database
3. In the root directory create a `.env` file providing values from the `.env.template` file.
4. Build frontend:

    - For production:
        ```
        yarn build 
        ```
    
    - For debug:
        ```
        yarn serve --port 8000
        ```

6. Build and run backend:
    ```
    swift run Run
    ```
