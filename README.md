# Simple Sinatra API for Short URLs

Test of a Simple API to shorten URLs with a custom domain name, build with Sinatra and ActiveRecord. I'm also trying to use some of [jsonapi.org](http://jsonapi.org) standards.

**Note:** This test API is far from done, and I'm using it mostly for learning.

## Enviroment variables

There is a `.env-sample` file in the project that contains the two variables "needed" for now.

## Instalation

Clone the repo, run `bundle` and run the migrations after using: `bundle exec rake db:setup`.

The project uses `foreman` to start the application process so `foreman start` will launch the server.

## JSON responses

After the `rake db:setup` there will be two objects seeded from the `db/seeds.rb` file and you can query them like this:

```sh
$ curl --request GET -i http://localhost:3000
HTTP/1.1 200 OK
Content-Type: application/json;charset=utf-8
Content-Length: 244
X-Content-Type-Options: nosniff
Server: WEBrick/1.3.1 (Ruby/2.0.0/2014-02-24)
Date: Sat, 05 Apr 2014 04:29:37 GMT
Connection: Keep-Alive

{"links":[{"id":1,"uri":"http://albertogrespan.com","href":"http://localhost:3000/inerr"},{"id":2,"uri":"http://codehero.co","href":"http://localhost:3000/ynt70"}]}
```

As you may notice, the `href` attribute will contain the shortened URL.

To request only a single element:

```sh
$ curl --request GET -i http://localhost:3000/ynt70
HTTP/1.1 200 OK
Content-Type: application/json;charset=utf-8
Content-Length: 40
X-Content-Type-Options: nosniff
Server: WEBrick/1.3.1 (Ruby/2.0.0/2014-02-24)
Date: Sat, 05 Apr 2014 04:30:38 GMT
Connection: Keep-Alive

{"links":[{"uri":"http://codehero.co"}]}
```

You can shorten a URL by sending a POST request like this:

```sh
$ curl -i -X POST -H "Accept: application/json" -d '{"links": [{"uri": "http://twitter.com/albertogg"}, {"uri": "http://something.com"}]}' "http://localhost:3000/"
HTTP/1.1 201 Created
Content-Type: application/json;charset=utf-8
Location: http://localhost:3000/links?ids=5,6
Content-Length: 169
X-Content-Type-Options: nosniff
Server: WEBrick/1.3.1 (Ruby/2.0.0/2014-02-24)
Date: Sat, 05 Apr 2014 04:38:50 GMT
Connection: Keep-Alive

{"links":[{"id":5,"uri":"http://twitter.com/albertogg","href":"http://localhost:3000/66bjj"},{"id":6,"uri":"http://something.com","href":"http://localhost:3000/l4gt7"}]}
```
As you can see the response returns the "correnct" HTTP response and a Location header with the created ids.

You can also request for multiple custom `ids`:

```sh
$ curl --request GET -i http://localhost:3000/?ids=1,5HTTP/1.1 200 OK
Content-Type: application/json;charset=utf-8
Content-Length: 174
X-Content-Type-Options: nosniff
Server: WEBrick/1.3.1 (Ruby/2.0.0/2014-02-24)
Date: Sat, 05 Apr 2014 04:40:59 GMT
Connection: Keep-Alive

{"links":[{"id":1,"uri":"http://albertogrespan.com","href":"http://localhost:3000/inerr"},{"id":5,"uri":"http://twitter.com/albertogg","href":"http://localhost:3000/66bjj"}]}%
```
