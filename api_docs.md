
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
      "_id": "5443cfde736d61104b150100",
      "_slugs": [
        "mung-bean"
      ],
      "binomial_name": "velit sit",
      "common_names": null,
      "created_at": "2014-10-19T14:51:10.419Z",
      "crop_data_source_id": null,
      "days_to_maturity": 26,
      "description": "Minus blanditiis numquam aspernatur eos et distinctio impedit.",
      "harvest_time": null,
      "height": 9,
      "image": null,
      "impressions": [

      ],
      "modifier_id": null,
      "name": "mung bean",
      "row_spacing": 9,
      "sowing_method": "container",
      "sowing_time": null,
      "spread": 8,
      "sun_requirements": "shade",
      "updated_at": "2014-10-19T14:51:10.419Z",
      "version": null
    }
  ]
}
```



# GET /api/crops/5443cfde736d61104b1e0100




## Response
```
{
  "crop": {
    "_id": "5443cfde736d61104b1e0100",
    "name": "plum Block",
    "binomial_name": "debitis accusantium",
    "description": "Et eum quod labore tempora expedita velit et.",
    "sun_requirements": "shade",
    "sowing_method": "container",
    "spread": 5,
    "days_to_maturity": 52,
    "row_spacing": 7,
    "height": 12
  }
}
```



# POST /api/guides



## Params
```
{
  "name": "brocolini in the desert",
  "overview": "something exotic",
  "crop_id": "5443cfda736d61104bf20000"
}
```


## Response
```
{
  "guide": {
    "_id": "5443cfda736d61104bf30000",
    "crop_id": "5443cfda736d61104bf20000",
    "user_id": "5443cfda736d61104bf10000",
    "stages": [

    ],
    "requirements": [

    ],
    "name": "brocolini in the desert",
    "overview": "something exotic",
    "featured_image": "/assets/leaf-grey.png",
    "location": null
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
  "crop_id": "5443cfd9736d61104bc20000"
}
```


## Response
```
{
  "guide": {
    "_id": "5443cfd9736d61104bc40000",
    "crop_id": "5443cfd9736d61104bc20000",
    "user_id": "5443cfd9736d61104bc30000",
    "stages": [

    ],
    "requirements": [

    ],
    "name": "Just 1 pixel.",
    "overview": "A tiny pixel test image.",
    "featured_image": "http://s3.amazonaws.com/openfarm-rick/test/media/guides/featured_images/5443cfd9736d61104bc40000.jpg?1413730265",
    "location": null
  }
}
```



# PUT /api/guides/5443cfd9736d61104bd00000



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
    "_id": "5443cfd9736d61104bd00000",
    "crop_id": "5443cfd9736d61104bcf0000",
    "user_id": "5443cfd9736d61104bce0000",
    "stages": [

    ],
    "requirements": [

    ],
    "name": "salmon Barrows",
    "overview": "updated",
    "featured_image": "/assets/leaf-grey.png",
    "location": null
  }
}
```



# GET /api/guides/5443cfda736d61104be60000




## Response
```
{
  "guide": {
    "_id": "5443cfda736d61104be60000",
    "crop_id": "5443cfda736d61104be50000",
    "user_id": "5443cfda736d61104be70000",
    "stages": [

    ],
    "requirements": [

    ],
    "name": "azure Murphy",
    "overview": "Pariatur id reprehenderit officiis perferendis beatae ut inventore.",
    "featured_image": "/assets/leaf-grey.png",
    "location": null
  }
}
```





# GET /api/requirement_options




## Response
```
{
  "requirement_options": [
    {
      "default_value": null,
      "type": "select",
      "name": "pink MacGyver",
      "options": [
        [
          "vel"
        ],
        [
          "optio"
        ]
      ]
    },
    {
      "default_value": null,
      "type": "range",
      "name": "lavender Carroll",
      "options": [
        [
          "ducimus"
        ],
        [
          "ducimus"
        ]
      ]
    }
  ]
}
```




# POST /api/requirements



## Params
```
{
  "name": "nemo",
  "required": "[\"dolores\", \"ea\"]",
  "guide_id": "5443cfd4736d61104b660000"
}
```


## Response
```
{
  "requirement": {
    "_id": "5443cfd4736d61104b670000",
    "guide": {
      "_id": "5443cfd4736d61104b660000",
      "_slugs": [
        "lime-dach"
      ],
      "crop_id": "5443cfd4736d61104b650000",
      "featured_image_content_type": null,
      "featured_image_file_name": null,
      "featured_image_file_size": null,
      "featured_image_fingerprint": null,
      "featured_image_updated_at": null,
      "impressions_field": 0,
      "location": null,
      "name": "lime Dach",
      "overview": "Officia sint inventore voluptatem.",
      "user_id": "5443cfd4736d61104b610000"
    },
    "name": "nemo",
    "required": "[\"dolores\", \"ea\"]"
  }
}
```







# PUT /api/requirements/5443cfd5736d61104b800000



## Params
```
{
  "required": "updated"
}
```


## Response
```
{
  "requirement": {
    "_id": "5443cfd5736d61104b800000",
    "guide": {
      "_id": "5443cfd5736d61104b7f0000",
      "_slugs": [
        "tan-abernathy"
      ],
      "crop_id": "5443cfd5736d61104b7e0000",
      "featured_image_content_type": null,
      "featured_image_file_name": null,
      "featured_image_file_size": null,
      "featured_image_fingerprint": null,
      "featured_image_updated_at": null,
      "impressions_field": 0,
      "location": null,
      "name": "tan Abernathy",
      "overview": "Vitae voluptatem sed et quia error.",
      "user_id": "5443cfd5736d61104b7a0000"
    },
    "name": "magenta Strosin",
    "required": "updated"
  }
}
```





# GET /api/requirements/5443cfd6736d61104b9f0000




## Response
```
{
  "requirement": {
    "_id": "5443cfd6736d61104b9f0000",
    "guide": {
      "_id": "5443cfd6736d61104b9d0000",
      "_slugs": [
        "yellow-stracke"
      ],
      "crop_id": "5443cfd6736d61104b9c0000",
      "featured_image_content_type": null,
      "featured_image_file_name": null,
      "featured_image_file_size": null,
      "featured_image_fingerprint": null,
      "featured_image_updated_at": null,
      "impressions_field": 0,
      "location": null,
      "name": "yellow Stracke",
      "overview": "Saepe quia laborum est amet vel.",
      "user_id": "5443cfd6736d61104b9e0000"
    },
    "name": "silver Kihn",
    "required": "[\"quo\", \"architecto\"]"
  }
}
```



# DELETE /api/requirements/5443cfd6736d61104baa0000






# GET /api/stage_options




## Response
```
{
  "stage_options": [
    {
      "default_value": "aliquid",
      "name": "azure Daniel",
      "slug": "azure-daniel",
      "description": "Consectetur ipsum accusantium sunt.",
      "order": 3
    },
    {
      "default_value": "rerum",
      "name": "turquoise Hirthe",
      "slug": "turquoise-hirthe",
      "description": "Sit perferendis voluptas cumque.",
      "order": 5
    }
  ]
}
```





# POST /api/stages



## Params
```
{
  "name": "eum",
  "instructions": "[\"Praesentium quo ad qui provident sit.\", \"Blanditiis beatae excepturi non sunt est et.\"]",
  "guide_id": "5443cfe2736d61104b440100"
}
```


## Response
```
{
  "stage": {
    "_id": "5443cfe2736d61104b450100",
    "guide": {
      "_id": "5443cfe2736d61104b440100",
      "_slugs": [
        "blue-runte"
      ],
      "crop_id": "5443cfe2736d61104b430100",
      "featured_image_content_type": null,
      "featured_image_file_name": null,
      "featured_image_file_size": null,
      "featured_image_fingerprint": null,
      "featured_image_updated_at": null,
      "impressions_field": 0,
      "location": null,
      "name": "blue Runte",
      "overview": "Sed voluptates assumenda occaecati minus.",
      "user_id": "5443cfe2736d61104b3f0100"
    },
    "name": "eum",
    "instructions": "[\"Praesentium quo ad qui provident sit.\", \"Blanditiis beatae excepturi non sunt est et.\"]"
  }
}
```




# PUT /api/stages/5443cfe1736d61104b320100



## Params
```
{
  "instructions": "updated"
}
```


## Response
```
{
  "stage": {
    "_id": "5443cfe1736d61104b320100",
    "guide": {
      "_id": "5443cfe1736d61104b310100",
      "_slugs": [
        "gold-goodwin"
      ],
      "crop_id": "5443cfe1736d61104b300100",
      "featured_image_content_type": null,
      "featured_image_file_name": null,
      "featured_image_file_size": null,
      "featured_image_fingerprint": null,
      "featured_image_updated_at": null,
      "impressions_field": 0,
      "location": null,
      "name": "gold Goodwin",
      "overview": "Similique eveniet harum perspiciatis sapiente molestias sit saepe itaque.",
      "user_id": "5443cfe1736d61104b2c0100"
    },
    "name": "magenta Lehner",
    "instructions": "updated"
  }
}
```



# GET /api/stages/5443cfe2736d61104b3e0100




## Response
```
{
  "stage": {
    "_id": "5443cfe2736d61104b3e0100",
    "guide": {
      "_id": "5443cfe2736d61104b3c0100",
      "_slugs": [
        "tan-kunde"
      ],
      "crop_id": "5443cfe2736d61104b3b0100",
      "featured_image_content_type": null,
      "featured_image_file_name": null,
      "featured_image_file_size": null,
      "featured_image_fingerprint": null,
      "featured_image_updated_at": null,
      "impressions_field": 0,
      "location": null,
      "name": "tan Kunde",
      "overview": "Ipsum ut ab magnam ut minima.",
      "user_id": "5443cfe2736d61104b3d0100"
    },
    "name": "yellow Bernhard",
    "instructions": "[\"Tempore atque enim illo soluta illum.\", \"Sunt quibusdam asperiores explicabo suscipit deleniti a aliquid.\"]"
  }
}
```




# DELETE /api/token

## Notes
You must be logged in to perform this action. No parameters are required. This is a log out action, essentially.






# POST /api/token

## Notes
Hit this API endpoint to generate an authentication token. Take the token that it returns and insert it as a request header like so: `Authorization: Token token=YOUR_TOKEN_HERE`



## Params
```
{
  "email": "carrie@klingkunze.info",
  "password": "password"
}
```


## Response
```
{
  "token": {
    "expiration": "2014-11-18T14:51:04.422Z",
    "secret": "carrie@klingkunze.info:3c2b54b7ca7f0032c7b999a0c3667690"
  }
}
```






