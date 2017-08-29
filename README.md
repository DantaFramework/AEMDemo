# Danta - AEM Demo Project

Danta is the agnostic multi-platform templating engine. enables developers and IT teams to use technologies they already know, expediting the creation and leveraging of reusable technical assets.

Danta - AEM Demo Project is the maven project contained source codes specifically for demoing Danta capability on AEM.

## Documentation

 * Read our [official documentation](http://danta.tikaltechnologies.io/docs) for more information.

## Prerequisites

 * [Danta - Parent Project](https://github.com/DantaFramework/Parent)
 * [Danta - API Project](https://github.com/DantaFramework/API)
 * [Danta - Core Project](https://github.com/DantaFramework/Core)
 * [Danta - AEM Project](https://github.com/DantaFramework/AEM)
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
    
## Maven Build Failure

If maven build failed with error message, similar to below

    Request failed: org.apache.jackrabbit.vault.packaging.PackageException: javax.jcr.nodetype.ConstraintViolationException: OakConstraint0021: /home/users/system/danta/zuskqdMThcLm-W1-QBV4[[rep:SystemUser]]: Mandatory property rep:principalName not found in a new node (500)

This is to "danta-config-service". To fix this:

 * Go to Package Manager (/crx/packmgr/index.jsp)
 * Upload [SystemUser-DantaDemo-1.0.0.zip](https://github.com/DantaFramework/AEMDemo/blob/master/SystemUser-DantaDemo-1.0.0.zip)
 * Install
 * Run maven build command again (re: Deploy to AEM)
 
## Credit

Special thanks to Jose Alvarez, who named Danta for the powerful ancient Mayan pyramid, La Danta. 
La Danta is the largest pyramid in El Mirador—the biggest Mayan city found in Petén, Guatemala.