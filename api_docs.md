
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
      "_id": "544107f1736d613f09130000",
      "_slugs": [
        "mung-bean"
      ],
      "binomial_name": "doloremque esse",
      "common_names": null,
      "created_at": "2014-10-17T12:13:37.109Z",
      "crop_data_source_id": null,
      "days_to_maturity": 30,
      "description": "Ad distinctio similique possimus itaque.",
      "harvest_time": null,
      "height": 12,
      "image": null,
      "impressions": [

      ],
      "modifier_id": null,
      "name": "mung bean",
      "row_spacing": 8,
      "sowing_method": "direct",
      "sowing_time": null,
      "spread": 16,
      "sun_requirements": "full",
      "updated_at": "2014-10-17T12:13:37.109Z",
      "version": null
    }
  ]
}
```



# GET /api/crops/544107f1736d613f091c0000




## Response
```
{
  "crop": {
    "_id": "544107f1736d613f091c0000",
    "name": "mint green Romaguera",
    "binomial_name": "illo deserunt",
    "description": "Dolore non est voluptas eum dolorem quisquam id nobis.",
    "sun_requirements": "shade",
    "sowing_method": "direct",
    "spread": 11,
    "days_to_maturity": 45,
    "row_spacing": 4,
    "height": 10
  }
}
```




# POST /api/guides



## Params
```
{
  "name": "brocolini in the desert",
  "overview": "something exotic",
  "crop_id": "544107f8736d613f09b60000"
}
```


## Response
```
{
  "guide": {
    "_id": "544107f8736d613f09b70000",
    "crop_id": "544107f8736d613f09b60000",
    "user_id": "544107f8736d613f09b50000",
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
  "crop_id": "544107f7736d613f09a90000"
}
```


## Response
```
{
  "guide": {
    "_id": "544107f7736d613f09ab0000",
    "crop_id": "544107f7736d613f09a90000",
    "user_id": "544107f7736d613f09aa0000",
    "stages": [

    ],
    "requirements": [

    ],
    "name": "Just 1 pixel.",
    "overview": "A tiny pixel test image.",
    "featured_image": "http://s3.amazonaws.com/openfarm-rick/test/media/guides/featured_images/544107f7736d613f09ab0000.jpg?1413548024",
    "location": null
  }
}
```




# GET /api/guides/544107f6736d613f097a0000




## Response
```
{
  "guide": {
    "_id": "544107f6736d613f097a0000",
    "crop_id": "544107f6736d613f09790000",
    "user_id": "544107f6736d613f097b0000",
    "stages": [

    ],
    "requirements": [

    ],
    "name": "magenta O'Connell",
    "overview": "Aperiam iure cumque ea quia.",
    "featured_image": "/assets/leaf-grey.png",
    "location": null
  }
}
```



# PUT /api/guides/544107f7736d613f09870000



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
    "_id": "544107f7736d613f09870000",
    "crop_id": "544107f6736d613f09860000",
    "user_id": "544107f6736d613f09850000",
    "stages": [

    ],
    "requirements": [

    ],
    "name": "violet Konopelski",
    "overview": "updated",
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
      "type": "range",
      "name": "grey Wolff",
      "options": [
        [
          "placeat"
        ],
        [
          "tempore"
        ]
      ]
    },
    {
      "default_value": null,
      "type": "range",
      "name": "gold Orn",
      "options": [
        2,
        8,
        4
      ]
    }
  ]
}
```




# POST /api/requirements



## Params
```
{
  "name": "sint",
  "required": "[\"tempora\", \"eum\"]",
  "guide_id": "544107fd736d613f09f90000"
}
```


## Response
```
{
  "requirement": {
    "_id": "544107fd736d613f09fa0000",
    "guide": {
      "_id": "544107fd736d613f09f90000",
      "_slugs": [
        "mint-green-bernhard"
      ],
      "crop_id": "544107fd736d613f09f80000",
      "featured_image_content_type": null,
      "featured_image_file_name": null,
      "featured_image_file_size": null,
      "featured_image_fingerprint": null,
      "featured_image_updated_at": null,
      "impressions_field": 0,
      "location": null,
      "name": "mint green Bernhard",
      "overview": "Reiciendis et nobis harum consequatur.",
      "user_id": "544107fd736d613f09f40000"
    },
    "name": "sint",
    "required": "[\"tempora\", \"eum\"]"
  }
}
```






# PUT /api/requirements/544107fc736d613f09e10000



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
    "_id": "544107fc736d613f09e10000",
    "guide": {
      "_id": "544107fc736d613f09e00000",
      "_slugs": [
        "plum-bode"
      ],
      "crop_id": "544107fc736d613f09df0000",
      "featured_image_content_type": null,
      "featured_image_file_name": null,
      "featured_image_file_size": null,
      "featured_image_fingerprint": null,
      "featured_image_updated_at": null,
      "impressions_field": 0,
      "location": null,
      "name": "plum Bode",
      "overview": "Quibusdam atque saepe vero fuga pariatur repudiandae aut.",
      "user_id": "544107fc736d613f09db0000"
    },
    "name": "orchid Conroy",
    "required": "updated"
  }
}
```




# DELETE /api/requirements/544107fd736d613f09010100







# GET /api/requirements/544107fe736d613f09180100




## Response
```
{
  "requirement": {
    "_id": "544107fe736d613f09180100",
    "guide": {
      "_id": "544107fe736d613f09160100",
      "_slugs": [
        "yellow-larson"
      ],
      "crop_id": "544107fe736d613f09150100",
      "featured_image_content_type": null,
      "featured_image_file_name": null,
      "featured_image_file_size": null,
      "featured_image_fingerprint": null,
      "featured_image_updated_at": null,
      "impressions_field": 0,
      "location": null,
      "name": "yellow Larson",
      "overview": "Sed repellendus nihil vel.",
      "user_id": "544107fe736d613f09170100"
    },
    "name": "salmon Feeney",
    "required": "[\"aliquid\", \"labore\"]"
  }
}
```




# GET /api/stage_options




## Response
```
{
  "stage_options": [
    {
      "default_value": "enim",
      "name": "purple Bauch",
      "slug": "purple-bauch",
      "description": "Labore iste in culpa facere.",
      "order": 4
    },
    {
      "default_value": "velit",
      "name": "olive Rosenbaum",
      "slug": "olive-rosenbaum",
      "description": "Quos accusamus voluptatem rerum.",
      "order": 3
    }
  ]
}
```






# POST /api/stages



## Params
```
{
  "name": "sint",
  "instructions": "[\"Neque consequatur deleniti dolore nihil laboriosam qui praesentium.\", \"Quam eum incidunt earum praesentium quisquam.\"]",
  "guide_id": "544107f5736d613f095f0000"
}
```


## Response
```
{
  "stage": {
    "_id": "544107f5736d613f09600000",
    "guide": {
      "_id": "544107f5736d613f095f0000",
      "_slugs": [
        "salmon-bartoletti"
      ],
      "crop_id": "544107f5736d613f095e0000",
      "featured_image_content_type": null,
      "featured_image_file_name": null,
      "featured_image_file_size": null,
      "featured_image_fingerprint": null,
      "featured_image_updated_at": null,
      "impressions_field": 0,
      "location": null,
      "name": "salmon Bartoletti",
      "overview": "Voluptatem quasi placeat qui illo maiores iste voluptate iusto.",
      "user_id": "544107f5736d613f095a0000"
    },
    "name": "sint",
    "instructions": "[\"Neque consequatur deleniti dolore nihil laboriosam qui praesentium.\", \"Quam eum incidunt earum praesentium quisquam.\"]"
  }
}
```




# GET /api/stages/544107f4736d613f09410000




## Response
```
{
  "stage": {
    "_id": "544107f4736d613f09410000",
    "guide": {
      "_id": "544107f4736d613f093f0000",
      "_slugs": [
        "lavender-swift"
      ],
      "crop_id": "544107f4736d613f093e0000",
      "featured_image_content_type": null,
      "featured_image_file_name": null,
      "featured_image_file_size": null,
      "featured_image_fingerprint": null,
      "featured_image_updated_at": null,
      "impressions_field": 0,
      "location": null,
      "name": "lavender Swift",
      "overview": "Soluta in eius qui nihil dignissimos omnis iusto.",
      "user_id": "544107f4736d613f09400000"
    },
    "name": "ivory Orn",
    "instructions": "[\"Et non aperiam officia minima.\", \"Est quaerat incidunt eos ratione id.\"]"
  }
}
```



# PUT /api/stages/544107f4736d613f09480000



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
    "_id": "544107f4736d613f09480000",
    "guide": {
      "_id": "544107f4736d613f09470000",
      "_slugs": [
        "purple-considine"
      ],
      "crop_id": "544107f4736d613f09460000",
      "featured_image_content_type": null,
      "featured_image_file_name": null,
      "featured_image_file_size": null,
      "featured_image_fingerprint": null,
      "featured_image_updated_at": null,
      "impressions_field": 0,
      "location": null,
      "name": "purple Considine",
      "overview": "Quidem ad velit repellendus fuga.",
      "user_id": "544107f4736d613f09420000"
    },
    "name": "sky blue Boyer",
    "instructions": "updated"
  }
}
```



# POST /api/token

## Notes
Hit this API endpoint to generate an authentication token. Take the token that it returns and insert it as a request header like so: `Authorization: Token token=YOUR_TOKEN_HERE`



## Params
```
{
  "email": "cornelius.metz@rath.info",
  "password": "password"
}
```


## Response
```
{
  "token": {
    "expiration": "2014-11-16T12:13:51.100Z",
    "secret": "cornelius.metz@rath.info:44a6a5d28d71e5125810a40340618ee9"
  }
}
```



# DELETE /api/token

## Notes
You must be logged in to perform this action. No parameters are required. This is a log out action, essentially.









