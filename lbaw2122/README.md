# Eventful

Eventful is a website that allows users to organize and participate in events, gathering all information needed in one single space.

## Project Components & Artifacts

* [ER: Requirements Specification](https://git.fe.up.pt/lbaw/lbaw2122/lbaw2122/-/wikis/er)
* [EBD: Database Specification](https://git.fe.up.pt/lbaw/lbaw2122/lbaw2122/-/wikis/ebd)
* [EAP: Architecture Specification and Prototype](https://git.fe.up.pt/lbaw/lbaw2122/lbaw2122/-/wikis/eap)
* [PA: Product and Presentation](https://git.fe.up.pt/lbaw/lbaw2122/lbaw2122/-/wikis/pa)

## Artefacts Checklist

* The artefacts checklist is available [**here**](https://docs.google.com/spreadsheets/d/17fUajNOO16hj5zFbtIyRWcwKu0kIl2VdCbS4QU1Rim4/edit#gid=537406521)

## Installation

The final version of the source code is available at: https://git.fe.up.pt/lbaw/lbaw2122/lbaw2122/-/tree/main/webapp. In order to install and run our project, the next steps must be followed:

1. Install Software dependencies:

1. 1. Docker;
   2. Docker Compose;
   3. PHP (>=8.0);
   4. Composer (>=2.0).

2. Download project from our repository;

3. Install local PHP dependencies (composer install);

4. Run local containers (docker-compose up);

5. Seed database from seed.sql file, which is only needed on first run or everytime the database script changes;

6. Start the development server (php artisan serve).

The website is located at http://localhost:8000 and pgAdmin4 at http://localhost:4321. After installing all the local dependencies, this process can be also done using:

```
docker run -it -p 8000:80 --name=lbaw2122 -e DB_DATABASE="lbaw2122" -e DB_SCHEMA="lbaw2122" -e DB_USERNAME="lbaw2122" -e DB_PASSWORD="uGoTThKe" git.fe.up.pt:5050/lbaw/lbaw2122/lbaw2122
```

## Usage

The final product is available at http://lbaw2122.lbaw.fe.up.pt/, (only works with VPN enabled). In order to ease the process of testing, we created several accounts that can be used to test a variety of features.

| **Description** |     **Email**      |                         **Password**                         |
| :-------------: | :----------------: | :----------------------------------------------------------: |
|  Administrator  | admin@eventful.com | thisIsAVerySecurePasswordThatShallGrantAdminPriviledgesToItsBeholder123! |
| Regular User 1  | vasco@eventful.com |                         abcd1234Q\|                          |
| Regular User 2  |   hoid@gmail.com   |                       LBAWisGreat123!                        |
| Regular User 3  |  zahel@gmail.com   |                          uUDSh2138!                          |
|  Blocked User   |  manny@gmail.com   |                          idkidkidk                           |

## Revision History

- 27/01/2022 - Added "Installation" and "Usage" sections.

## Team

* Adriano Soares, up201904873@fe.up.pt
* Filipe Campos, up201905609@fe.up.pt
* Francisco Cerqueira, up201905337@fe.up.pt
* Vasco Alves, up201808031@fe.up.pt

***
GROUP2122, 30/11/2021
