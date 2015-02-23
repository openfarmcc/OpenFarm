
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
      "_id": "545226ab736d61b45d800100",
      "_slugs": [
        "mung-bean"
      ],
      "binomial_name": "quis ad",
      "common_names": null,
      "created_at": "2014-10-30T11:53:15.112Z",
      "crop_data_source_id": null,
      "days_to_maturity": 21,
      "description": "Numquam tempore ab itaque temporibus odit magni placeat.",
      "harvest_time": null,
      "height": 16,
      "image": null,
      "impressions": [

      ],
      "modifier_id": null,
      "name": "mung bean",
      "row_spacing": 10,
      "sowing_method": "direct",
      "sowing_time": null,
      "spread": 4,
      "sun_requirements": "shade",
      "updated_at": "2014-10-30T11:53:15.112Z",
      "version": null
    }
  ]
}
```



# GET /api/crops/545226aa736d61b45d7f0100




## Response
```
{
  "crop": {
    "_id": "545226aa736d61b45d7f0100",
    "name": "azure Durgan",
    "binomial_name": "omnis voluptas",
    "description": "Molestias ex qui qui.",
    "sun_requirements": "shade",
    "sowing_method": "direct",
    "spread": 9,
    "days_to_maturity": 13,
    "row_spacing": 5,
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
  "crop_id": "5452268d736d61b45d160000"
}
```


## Response
```
{
  "guide": {
    "_id": "5452268d736d61b45d170000",
    "crop_id": "5452268d736d61b45d160000",
    "user_id": "5452268d736d61b45d150000",
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
  "crop_id": "5452268c736d61b45d090000"
}
```


## Response
```
{
  "guide": {
    "_id": "5452268c736d61b45d0b0000",
    "crop_id": "5452268c736d61b45d090000",
    "user_id": "5452268c736d61b45d0a0000",
    "stages": [

    ],
    "requirements": [

    ],
    "name": "Just 1 pixel.",
    "overview": "A tiny pixel test image.",
    "featured_image": "http://s3.amazonaws.com/openfarm-rick/test/media/guides/featured_images/5452268c736d61b45d0b0000.jpg?1414669965",
    "location": null
  }
}
```




# GET /api/guides/5452268e736d61b45d2f0000




## Response
```
{
  "guide": {
    "_id": "5452268e736d61b45d2f0000",
    "crop_id": "5452268e736d61b45d2e0000",
    "user_id": "5452268e736d61b45d300000",
    "stages": [

    ],
    "requirements": [

    ],
    "name": "azure Hettinger",
    "overview": "Nulla debitis nisi adipisci commodi ab excepturi est.",
    "featured_image": "/assets/leaf-grey.png",
    "location": null
  }
}
```




# PUT /api/guides/5452268f736d61b45d530000



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
    "_id": "5452268f736d61b45d530000",
    "crop_id": "5452268f736d61b45d520000",
    "user_id": "5452268f736d61b45d510000",
    "stages": [

    ],
    "requirements": [

    ],
    "name": "azure Lockman",
    "overview": "updated",
    "featured_image": "/assets/leaf-grey.png",
    "location": null
  }
}
```


# DELETE /api/guides/5452268f736d61b45d530000



# GET /api/requirement_options




## Response
```
{
  "requirement_options": [
    {
      "default_value": null,
      "type": "select",
      "name": "white Torp",
      "options": [
        [
          "molestias"
        ],
        [
          "eaque"
        ]
      ]
    },
    {
      "default_value": null,
      "type": "select",
      "name": "lavender Kling",
      "options": [
        [
          "quia"
        ],
        [
          "quam"
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
  "name": "voluptate",
  "required": "[\"illum\", \"magnam\"]",
  "guide_id": "54522696736d61b45de10000"
}
```


## Response
```
{
  "requirement": {
    "_id": "54522696736d61b45de20000",
    "guide": {
      "_id": "54522696736d61b45de10000",
      "_slugs": [
        "maroon-ritchie"
      ],
      "crop_id": "54522696736d61b45de00000",
      "featured_image_content_type": null,
      "featured_image_file_name": null,
      "featured_image_file_size": null,
      "featured_image_fingerprint": null,
      "featured_image_updated_at": null,
      "impressions_field": 0,
      "location": null,
      "name": "maroon Ritchie",
      "overview": "Rerum voluptas eligendi earum debitis voluptatem.",
      "user_id": "54522696736d61b45ddc0000"
    },
    "name": "voluptate",
    "required": "[\"illum\", \"magnam\"]"
  }
}
```






# DELETE /api/requirements/54522694736d61b45da30000








# GET /api/requirements/54522695736d61b45dbb0000




## Response
```
{
  "requirement": {
    "_id": "54522695736d61b45dbb0000",
    "guide": {
      "_id": "54522695736d61b45db90000",
      "_slugs": [
        "grey-miller"
      ],
      "crop_id": "54522695736d61b45db80000",
      "featured_image_content_type": null,
      "featured_image_file_name": null,
      "featured_image_file_size": null,
      "featured_image_fingerprint": null,
      "featured_image_updated_at": null,
      "impressions_field": 0,
      "location": null,
      "name": "grey Miller",
      "overview": "In laboriosam rem dolor nihil ipsum aut.",
      "user_id": "54522695736d61b45dba0000"
    },
    "name": "salmon Shanahan",
    "required": "[\"doloremque\", \"aut\"]"
  }
}
```




# PUT /api/requirements/54522696736d61b45dd40000



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
    "_id": "54522696736d61b45dd40000",
    "guide": {
      "_id": "54522696736d61b45dd30000",
      "_slugs": [
        "plum-ryan"
      ],
      "crop_id": "54522696736d61b45dd20000",
      "featured_image_content_type": null,
      "featured_image_file_name": null,
      "featured_image_file_size": null,
      "featured_image_fingerprint": null,
      "featured_image_updated_at": null,
      "impressions_field": 0,
      "location": null,
      "name": "plum Ryan",
      "overview": "Facilis repudiandae sapiente labore.",
      "user_id": "54522696736d61b45dce0000"
    },
    "name": "red Crooks",
    "required": "updated"
  }
}
```



# GET /api/stage_options




## Response
```
{
  "stage_options": [
    {
      "default_value": "autem",
      "name": "purple McDermott",
      "slug": "purple-mcdermott",
      "description": "Qui sunt non odio nulla.",
      "order": 1
    },
    {
      "default_value": "quia",
      "name": "sky blue Schumm",
      "slug": "sky-blue-schumm",
      "description": "Velit tempore nisi sint sed autem ea deserunt ut.",
      "order": 7
    }
  ]
}
```






# POST /api/stages



## Params
```
{
  "name": "doloribus",
  "instructions": "[\"Ullam voluptas quae modi sit.\", \"Consequuntur sit optio cum rerum nobis est et.\"]",
  "guide_id": "545226a3736d61b45d290100"
}
```


## Response
```
{
  "stage": {
    "_id": "545226a3736d61b45d2a0100",
    "guide": {
      "_id": "545226a3736d61b45d290100",
      "_slugs": [
        "cyan-nikolaus"
      ],
      "crop_id": "545226a3736d61b45d280100",
      "featured_image_content_type": null,
      "featured_image_file_name": null,
      "featured_image_file_size": null,
      "featured_image_fingerprint": null,
      "featured_image_updated_at": null,
      "impressions_field": 0,
      "location": null,
      "name": "cyan Nikolaus",
      "overview": "Aut quae placeat dolores suscipit accusantium rerum esse.",
      "user_id": "545226a3736d61b45d240100"
    },
    "name": "doloribus",
    "instructions": "[\"Ullam voluptas quae modi sit.\", \"Consequuntur sit optio cum rerum nobis est et.\"]"
  }
}
```



# GET /api/stages/545226a4736d61b45d390100




## Response
```
{
  "stage": {
    "_id": "545226a4736d61b45d390100",
    "guide": {
      "_id": "545226a4736d61b45d370100",
      "_slugs": [
        "cyan-kautzer"
      ],
      "crop_id": "545226a4736d61b45d360100",
      "featured_image_content_type": null,
      "featured_image_file_name": null,
      "featured_image_file_size": null,
      "featured_image_fingerprint": null,
      "featured_image_updated_at": null,
      "impressions_field": 0,
      "location": null,
      "name": "cyan Kautzer",
      "overview": "Dolore neque ut aut omnis ipsum molestiae non corrupti.",
      "user_id": "545226a4736d61b45d380100"
    },
    "name": "silver McLaughlin",
    "instructions": "[\"Aperiam cumque asperiores quia.\", \"Aut autem et occaecati est.\"]"
  }
}
```




# PUT /api/stages/545226a4736d61b45d4c0100



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
    "_id": "545226a4736d61b45d4c0100",
    "guide": {
      "_id": "545226a4736d61b45d4b0100",
      "_slugs": [
        "fuchsia-hessel"
      ],
      "crop_id": "545226a4736d61b45d4a0100",
      "featured_image_content_type": null,
      "featured_image_file_name": null,
      "featured_image_file_size": null,
      "featured_image_fingerprint": null,
      "featured_image_updated_at": null,
      "impressions_field": 0,
      "location": null,
      "name": "fuchsia Hessel",
      "overview": "Quidem id neque accusantium ut et enim dignissimos.",
      "user_id": "545226a4736d61b45d460100"
    },
    "name": "magenta Schmitt",
    "instructions": "updated"
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
  "email": "manuel@treutel.org",
  "password": "password"
}
```


## Response
```
{
  "token": {
    "expiration": "2014-11-29T11:53:10.537Z",
    "secret": "manuel@treutel.org:ca80cf3f7e66166bc37af0e4d56146fd"
  }
}
```



