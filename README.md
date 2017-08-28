# Danta - AEM Demo Project

Danta - AEM Demo Project is the maven project contained source codes specifically for demoing Danta capability on AEM.

## Documentation

 * Read our [official documentation](http://danta.technologies.io/docs/) for more information.

## Prerequisites

 * [Danta - Parent Project](https://github.com/DataFramework/Parent)
 * [Danta - API Project](https://github.com/DataFramework/API)
 * [Danta - Core Project](https://github.com/DataFramework/Core)
 * [Danta - AEM Project](https://github.com/DataFramework/AEM)
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

    mvn clean install -Pdeploy-aem

Build to publish instance

    mvn clean install -Pdeploy-aem-publish