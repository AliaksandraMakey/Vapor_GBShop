# Vapor GBShop
[![Swift 5.2](https://img.shields.io/badge/swift-5.2-orange.svg?style=flat)](http://swift.org)
[![Vapor 4](https://img.shields.io/badge/vapor-4.0-blue.svg?style=flat)](https://vapor.codes)

 Часть функционала аутентификации была взята из общедоступного примера, а остальной функционал был дополнен и реализован самостоятельно.

## Особенности
* Регистрация пользователя
* Вход пользователя
* Подтверждение почты
* Токены обновления и доступа
* Аутентификация через JWT
* Mailgun

## Константы
Constants.swift содержит константы, связанные с временем жизни токенов.

## Mailgun
Шаблон использует VaporMailgunService и может быть настроен в соответствии с документацией. Extensions/Mailgun+Domains.swift содержит домены.

## JWT
Этот пакет использует JWT для токенов доступа. По умолчанию он загружает учетные данные JWT из файла JWKS под названием keypair.jwks в корневом каталоге. Вы можете сгенерировать ключевую пару JWKS на сайте https://mkjwk.org/.
