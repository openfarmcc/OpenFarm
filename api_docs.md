
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
      "_id": "543d0c16736d610379350000",
      "_slugs": [
        "mung-bean"
      ],
      "binomial_name": "velit quam",
      "common_names": null,
      "created_at": "2014-10-14T11:42:14.127Z",
      "crop_data_source_id": null,
      "days_to_maturity": 21,
      "description": "Quam dicta rem voluptate autem aut.",
      "harvest_time": null,
      "height": 7,
      "image": null,
      "impressions": [

      ],
      "modifier_id": null,
      "name": "mung bean",
      "row_spacing": 14,
      "sowing_method": "container",
      "sowing_time": null,
      "spread": 8,
      "sun_requirements": "shade",
      "updated_at": "2014-10-14T11:42:14.127Z",
      "version": null
    }
  ]
}
```



# GET /api/crops/543d0c16736d6103793b0000




## Response
```
{
  "crop": {
    "_id": "543d0c16736d6103793b0000",
    "name": "green Friesen",
    "binomial_name": "magni et",
    "description": "Cum reprehenderit ullam eum quisquam similique quos laboriosam.",
    "sun_requirements": "full",
    "sowing_method": "direct",
    "spread": 7,
    "days_to_maturity": 39,
    "row_spacing": 12,
    "height": 16
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
  "crop_id": "543d0c26736d610379050100"
}
```


## Response
```
{
  "guide": {
    "_id": "543d0c26736d610379070100",
    "crop_id": "543d0c26736d610379050100",
    "user_id": "543d0c26736d610379060100",
    "stages": [

    ],
    "requirements": [

    ],
    "name": "Just 1 pixel.",
    "overview": "A tiny pixel test image.",
    "featured_image": "http://s3.amazonaws.com/openfarm-rick/test/media/guides/featured_images/543d0c26736d610379070100.jpg?1413286950",
    "location": null
  }
}
```




# POST /api/guides



## Params
```
{
  "name": "brocolini in the desert",
  "overview": "something exotic",
  "crop_id": "543d0c28736d610379360100"
}
```


## Response
```
{
  "guide": {
    "_id": "543d0c28736d610379370100",
    "crop_id": "543d0c28736d610379360100",
    "user_id": "543d0c28736d610379350100",
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





# GET /api/guides/543d0c27736d6103792a0100




## Response
```
{
  "guide": {
    "_id": "543d0c27736d6103792a0100",
    "crop_id": "543d0c27736d610379290100",
    "user_id": "543d0c27736d6103792b0100",
    "stages": [

    ],
    "requirements": [

    ],
    "name": "cyan MacGyver",
    "overview": "Ea illum aspernatur et cum molestias.",
    "featured_image": "/assets/leaf-grey.png",
    "location": null
  }
}
```



# PUT /api/guides/543d0c28736d610379430100



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
    "_id": "543d0c28736d610379430100",
    "crop_id": "543d0c28736d610379420100",
    "user_id": "543d0c28736d610379410100",
    "stages": [

    ],
    "requirements": [

    ],
    "name": "red Ondricka",
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
      "type": "select",
      "name": "cyan Stiedemann",
      "options": [
        6,
        1,
        1
      ]
    },
    {
      "default_value": null,
      "type": "select",
      "name": "silver Russel",
      "options": [
        5,
        6,
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
  "name": "eius",
  "required": "[\"voluptas\", \"animi\"]",
  "guide_id": "543d0c1a736d610379960000"
}
```


## Response
```
{
  "requirement": {
    "_id": "543d0c1a736d610379970000",
    "guide": {
      "_id": "543d0c1a736d610379960000",
      "_slugs": [
        "mint-green-wyman"
      ],
      "crop_id": "543d0c1a736d610379950000",
      "featured_image_content_type": null,
      "featured_image_file_name": null,
      "featured_image_file_size": null,
      "featured_image_fingerprint": null,
      "featured_image_updated_at": null,
      "impressions_field": 0,
      "location": null,
      "name": "mint green Wyman",
      "overview": "Et eum molestiae mollitia ut voluptas.",
      "user_id": "543d0c1a736d610379910000"
    },
    "name": "eius",
    "required": "[\"voluptas\", \"animi\"]"
  }
}
```







# GET /api/requirements/543d0c19736d6103797b0000




## Response
```
{
  "requirement": {
    "_id": "543d0c19736d6103797b0000",
    "guide": {
      "_id": "543d0c19736d610379790000",
      "_slugs": [
        "turquoise-olson"
      ],
      "crop_id": "543d0c19736d610379780000",
      "featured_image_content_type": null,
      "featured_image_file_name": null,
      "featured_image_file_size": null,
      "featured_image_fingerprint": null,
      "featured_image_updated_at": null,
      "impressions_field": 0,
      "location": null,
      "name": "turquoise Olson",
      "overview": "Corporis suscipit quasi voluptas et.",
      "user_id": "543d0c19736d6103797a0000"
    },
    "name": "violet Bergstrom",
    "required": "[\"aut\", \"rerum\"]"
  }
}
```




# DELETE /api/requirements/543d0c19736d6103798a0000








# PUT /api/requirements/543d0c1b736d610379b50000



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
    "_id": "543d0c1b736d610379b50000",
    "guide": {
      "_id": "543d0c1b736d610379b40000",
      "_slugs": [
        "mint-green-donnelly"
      ],
      "crop_id": "543d0c1b736d610379b30000",
      "featured_image_content_type": null,
      "featured_image_file_name": null,
      "featured_image_file_size": null,
      "featured_image_fingerprint": null,
      "featured_image_updated_at": null,
      "impressions_field": 0,
      "location": null,
      "name": "mint green Donnelly",
      "overview": "Aut maxime provident ut magni ullam repudiandae assumenda est.",
      "user_id": "543d0c1b736d610379af0000"
    },
    "name": "turquoise Price",
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
      "default_value": "aut",
      "name": "turquoise Quigley",
      "slug": "turquoise-quigley",
      "description": "Iure consequatur sed ut ut voluptatem enim voluptatem suscipit.",
      "order": 6
    },
    {
      "default_value": "mollitia",
      "name": "lavender Corwin",
      "slug": "lavender-corwin",
      "description": "Omnis sint esse sit omnis in aut.",
      "order": 5
    }
  ]
}
```



# POST /api/stages



## Params
```
{
  "name": "placeat",
  "instructions": "[\"Amet officia fugit ipsa et eum ut voluptatem.\", \"Ut animi illo est.\"]",
  "guide_id": "543d0c14736d610379260000"
}
```


## Response
```
{
  "stage": {
    "_id": "543d0c14736d610379270000",
    "guide": {
      "_id": "543d0c14736d610379260000",
      "_slugs": [
        "blue-ward"
      ],
      "crop_id": "543d0c14736d610379250000",
      "featured_image_content_type": null,
      "featured_image_file_name": null,
      "featured_image_file_size": null,
      "featured_image_fingerprint": null,
      "featured_image_updated_at": null,
      "impressions_field": 0,
      "location": null,
      "name": "blue Ward",
      "overview": "Ad iure est quibusdam exercitationem perferendis.",
      "user_id": "543d0c14736d610379210000"
    },
    "name": "placeat",
    "instructions": "[\"Amet officia fugit ipsa et eum ut voluptatem.\", \"Ut animi illo est.\"]"
  }
}
```







# GET /api/stages/543d0c14736d610379200000




## Response
```
{
  "stage": {
    "_id": "543d0c14736d610379200000",
    "guide": {
      "_id": "543d0c14736d6103791e0000",
      "_slugs": [
        "red-deckow"
      ],
      "crop_id": "543d0c14736d6103791d0000",
      "featured_image_content_type": null,
      "featured_image_file_name": null,
      "featured_image_file_size": null,
      "featured_image_fingerprint": null,
      "featured_image_updated_at": null,
      "impressions_field": 0,
      "location": null,
      "name": "red Deckow",
      "overview": "Nemo facere a ad cum praesentium enim adipisci.",
      "user_id": "543d0c14736d6103791f0000"
    },
    "name": "azure Flatley",
    "instructions": "[\"Sed voluptatem ut maiores cupiditate.\", \"Quo excepturi autem nihil et consectetur sunt quam.\"]"
  }
}
```



# PUT /api/stages/543d0c15736d6103792e0000



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
    "_id": "543d0c15736d6103792e0000",
    "guide": {
      "_id": "543d0c15736d6103792d0000",
      "_slugs": [
        "purple-zemlak"
      ],
      "crop_id": "543d0c15736d6103792c0000",
      "featured_image_content_type": null,
      "featured_image_file_name": null,
      "featured_image_file_size": null,
      "featured_image_fingerprint": null,
      "featured_image_updated_at": null,
      "impressions_field": 0,
      "location": null,
      "name": "purple Zemlak",
      "overview": "Id dicta enim impedit rerum.",
      "user_id": "543d0c14736d610379280000"
    },
    "name": "red Quigley",
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
  "email": "jacky_lynch@brekke.org",
  "password": "password"
}
```


## Response
```
{
  "token": {
    "expiration": "2014-11-13T11:42:22.618Z",
    "secret": "jacky_lynch@brekke.org:08717f69a40b2a2df78a57bbd97a40d5"
  }
}
```





# DELETE /api/token

## Notes
You must be logged in to perform this action. No parameters are required. This is a log out action, essentially.






