Что за шаблон?
===

Это болванка приложения на Rails 4.2, которую удобно брать за основу для
создания новых проектов.

Пример
===

    $ \curl -L https://raw.github.com/TinkerDev/rails4_template/master/bootstrap.sh | bash -s Project

а если у нас уже есть пустой репозиторий на github, то

    $ \curl -L https://raw.github.com/TinkerDev/rails4_template/master/bootstrap.sh | bash -s Project --git git@github.com:BrandyMint/masha.git


Что при этом происходится?

1. Клонируется проект `rails4_template` в каталог производный от
указанного имени.
2. Рельсовое приложение переименуется в указанное имя
(`Project::Application`)
3. Базу тоже назовут в ее честь.
4. Запустится `bundle update`
5. Пропишется указанный репозиторий (если указан) и зальется первый
комит.

Что делать дальше?
==================

1. Настроить `./config/application.yml` и `./config/database.yml`
2. Зарегистрировать проект в errbit и записать ключи `./config/initializers/airbrake.rb`
3. Поправить `README.md`

Константы
=========

При генерации проекта происходит автозамена:

Rails4Template -> НазваниеПриложения -> Project
http://Rails4Template.icfdev.ru/ -> url -> http://project.ru/
HOSTNAME -> host -> project.ru
ttt -> НазваниеБазы -> project


Базовые вещи
============

* Все вьюхи делаются с поддержкой bootstrap (формы, меню)

Хелпы по гемам
============

SimpleNavigation: [https://github.com/codeplant/simple-navigation/wiki]
FactoryGirl: [https://github.com/thoughtbot/factory_girl]
