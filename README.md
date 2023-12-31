#  Дипломная работа по профессии «Системный администратор» FSYS-19 Мусиенко Александр  
  
## Задача
Ключевая задача — разработать отказоустойчивую инфраструктуру для сайта, включающую мониторинг, сбор логов и резервное копирование основных данных. Инфраструктура должна размещаться в [Yandex Cloud](https://cloud.yandex.com/) и отвечать минимальным стандартам безопасности: запрещается выкладывать токен от облака в git. Используйте [инструкцию](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-quickstart#get-credentials).  

[Полное задание к дипломной работе:](https://github.com/netology-code/sys-diplom/tree/diplom-zabbix)  

  
## Доступ к сайту http://158.160.128.61/  

## Доступ к Zabbix http://158.160.102.23/
Логин:   admin  
Пароль:  zabbix  

## Доступ к Elastic http://158.160.112.2:5601/  

---
# Подготовка к развёртке
---

## Для развёртки потребуется:

- скачать репозитарий

- Прописать данные облака: token, cloud_id, folder_id  
<img src = "img/001_01.png" width = 60%>

- сгенерировать ключи в папку */terraform/keys/* командой **ssh-keygen** и прописать ключи в файл */terraform/meta.yaml*
 
- Потребуются установочные пакеты elasticsearch, filebeat, kibana
Можно взять на сайте [Yandex зеркало](https://mirror.yandex.ru/mirrors/elastic/)
Пакеты положить в папку */distribute*, если в другую, то адрес надо поменять */ansible/elk/vars.yml*
Необходимо взять одну версию, номер версии прописать в файле */ansible/elk/vars.yml*

---
# Развёртка
---

## Развёртка осуществляется терраформом находясь в папке дистрибутива развернуть командой: **terraform apply**  

## Разворачивается за 5-8 минут   

- Успешная развёртка окончится выдачей назначенных ip адресов.   

<img src = "img/002_01.png" width = 40%>   

В Консоли яндекс клауда развернутся следующие сервисы:  

<img src = "img/003_01.png" width = 100%>  
  
-- одна сеть **bastion-network**  
-- две подсети **bastion-internal-segment** и **bastion-external-segment**  
-- Балансировщик **alb-lb** с роутером **web-servers-router**, целевой группой **tg-web**  
-- группы безопасности 10 штук  

<img src = "img/004_01.png" width = 100%>  

-- развернётся 6 виртуальных машин:   

<img src = "img/005_01.png" width = 100%>   
  
-- снимки дисков осуществляются по расписанию (файл /terraform/snapshot.tf)  
(С предыдущего варианта снимки, т.к. машины выполнены перываемыми, пришлось переделать инфраструктуру)

<img src = "img/006_01.png" width = 100%>   

Машины выполнены прерываемыми

```yaml

  scheduling_policy {
    preemptible = true
  }
```
(Сейчас выставленно в false)

## Донастройка осуществляется ansibl-ом из папки ansible:  
  
- инвенторка формируется терраформом на стадии развёртки. /ansible/hosts.ini  
  
- Также в папке лежит конфиг /ansible/ansible.cfg  
  
- Прописываем ранее сгенерированный ssh-ключ на хостовую машину: *ssh-add ../terraform/keys/id_rsa*  
   
<img src = "img/001_04.png" width = 100%>  
  
- Далее пробуем пинговать машины из списка хостов: *ansible all -m ping*  
На запрос отпечатка отвечаем **yes**  (С первого раза не все машины пингуются со второго - все)

<img src = "img/002_04.png" width = 100%>   
  
- Устанавливаем пакеты на хостовую машину:  
*ansible-playbook first_playbook.yml*  
  
<img src = "img/004_04.png" width = 100%>   
  
- Далее устанавливаем необходимые пакеты и переносим сайт командой  
*ansible-playbook sekond_playbook.yml --vault-password-file pass -v*
  
<img src = "img/003_04.png" width = 100%>  
   
Успешное выполнение плэйбука  
  
<img src = "img/005_04.png" width = 100%>  
  

# В результате
## установится сайт: 

<img src = "img/001_02.png" width = 60%>  
<img src = "img/002_02.png" width = 60%>  
  
## Развернётся забикс на забикс сервер, на остальные машины установятся агенты:  
  
<img src = "img/003_02.png" width = 100%>   

И будет собираться метрика  
  
<img src = "img/004_02.png" width = 100%>  

## Развернётся Elasticsearch и kibana

## Filebeat с вэбсерверов отправляет метрику

<img src = "img/005_02.png" width = 100%>  

<img src = "img/006_02.png" width = 100%>  
