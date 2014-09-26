
# GET /api/crops


## Params
```
{
  "query": "mung"
}
```



## Response
```
{
  "crops": [
    {
      "_id": "54255fab736d619c822c0000",
      "name": "mung bean",
      "binomial_name": "quidem nobis",
      "description": "Sequi distinctio aut optio pariatur eaque dolores voluptates.",
      "sun_requirements": "shade",
      "sowing_method": "container",
      "spread": 8,
      "days_to_maturity": 38,
      "row_spacing": 8,
      "height": 12
    }
  ]
}
```



# GET /api/crops/54255faa736d619c822b0000


## Params
```
{
}
```



## Response
```
{
  "crop": {
    "_id": "54255faa736d619c822b0000",
    "name": "azure Prohaska",
    "binomial_name": "et nesciunt",
    "description": "Repellendus libero odio commodi.",
    "sun_requirements": "full",
    "sowing_method": "direct",
    "spread": 10,
    "days_to_maturity": 19,
    "row_spacing": 9,
    "height": 11
  }
}
```




# POST /api/guides


## Params
```
{
  "name": "Just 1 pixel.",
  "overview": "A tiny pixel test image.",
  "featured_image": "http://placehold.it/1x1.jpg",
  "crop_id": "54255fab736d619c82380000"
}
```



## Response
```
{
  "guide": {
    "_id": "54255fab736d619c823a0000",
    "crop_id": "54255fab736d619c82380000",
    "user_id": "54255fab736d619c82390000",
    "stages": [

    ],
    "requirements": [

    ],
    "name": "Just 1 pixel.",
    "overview": "A tiny pixel test image.",
    "featured_image": "http://s3.amazonaws.com/openfarm-rick/test/media/guides/featured_images/54255fab736d619c823a0000.jpg?1411735467"
  }
}
```



# POST /api/guides


## Params
```
{
  "name": "brocolini in the desert",
  "overview": "something exotic",
  "crop_id": "54255fab736d619c82810000"
}
```



## Response
```
{
  "guide": {
    "_id": "54255fab736d619c82820000",
    "crop_id": "54255fab736d619c82810000",
    "user_id": "54255fab736d619c82800000",
    "stages": [

    ],
    "requirements": [

    ],
    "name": "brocolini in the desert",
    "overview": "something exotic",
    "featured_image": "https://openfarm.cc/img/page.png"
  }
}
```




# GET /api/guides/54255fab736d619c825c0000


## Params
```
{
}
```



## Response
```
{
  "guide": {
    "_id": "54255fab736d619c825c0000",
    "crop_id": "54255fab736d619c825b0000",
    "user_id": "54255fab736d619c825d0000",
    "stages": [

    ],
    "requirements": [

    ],
    "name": "lime Greenfelder",
    "overview": "Voluptatem similique ipsum perspiciatis eos.",
    "featured_image": "https://openfarm.cc/img/page.png"
  }
}
```




# PUT /api/guides/54255fab736d619c82760000


## Params
```
{
  "overview": "updated"
}
```



## Response
```
{
  "guide": {
    "_id": "54255fab736d619c82760000",
    "crop_id": "54255fab736d619c82750000",
    "user_id": "54255fab736d619c82740000",
    "stages": [

    ],
    "requirements": [

    ],
    "name": "magenta Kuhn",
    "overview": "updated",
    "featured_image": "https://openfarm.cc/img/page.png"
  }
}
```




# POST /api/token


## Params
```
{
  "email": "lew.harris@loweskiles.net",
  "password": "password"
}
```



## Response
```
{
  "token": {
    "expiration": "2014-10-26T12:44:28.108Z",
    "secret": "lew.harris@loweskiles.net:ce4e8502abbe7ac1d28523f88808d89a"
  }
}
```


