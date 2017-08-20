# LayerX - AEM Demo Project

LayerX - AEM Demo Project is the maven project contained source codes specifically for demoing LayerX capability on AEM.

## Documentation

 * Read our [official documentation](http://layerx.technologies.io/docs/) for more information.

## Prerequisites

 * [LayerX - Parent Project](https://github.com/layerx/Parent)
 * [LayerX - API Project](https://github.com/layerx/API)
 * [LayerX - Core Project](https://github.com/layerx/Core)
 * [LayerX - AEM Project](https://github.com/layerx/AEM)
 * Java 8
 * AEM 6.2 or later (for integration with AEM)

## License

Read [License](LICENSE) for more licensing information.

## Contribute

Read [here](CONTRIBUTING.md) for more information.

## Compile

    mvn clean install

## Deploy to AEM

Build to author instance

    mvn clean install -PautoInstallPackage

Build to publish instance

    mvn clean install -PautoInstallPackagePublish