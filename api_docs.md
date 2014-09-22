
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
      "_id": "541f6f97736d61d975340000",
      "name": "mung bean",
      "binomial_name": "ut ut",
      "description": "Magni placeat eius quia.",
      "sun_requirements": "shade",
      "sowing_method": "direct",
      "spread": 9,
      "days_to_maturity": 71,
      "row_spacing": 10,
      "height": 9
    }
  ]
}
```

# GET /api/crops/541f6f97736d61d9753d0000

## Params
```
{
}
```

## Response
```
{
  "crop": {
    "_id": "541f6f97736d61d9753d0000",
    "name": "azure Adams",
    "binomial_name": "voluptatem nostrum",
    "description": "Ad exercitationem illo sint doloremque perferendis dolor.",
    "sun_requirements": "shade",
    "sowing_method": "container",
    "spread": 7,
    "days_to_maturity": 28,
    "row_spacing": 15,
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
  "crop_id": "541f6f98736d61d975670000"
}
```

## Response
```
{
  "guide": {
    "_id": "541f6f98736d61d975680000",
    "crop_id": "541f6f98736d61d975670000",
    "user_id": "541f6f98736d61d975660000",
    "stages": [

    ],
    "requirements": [

    ],
    "name": "brocolini in the desert",
    "overview": "something exotic",
    "featured_image": "http://openfarm.cc/img/page.png"
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
  "crop_id": "541f6f98736d61d975720000"
}
```

## Response
```
{
  "guide": {
    "_id": "541f6f98736d61d975740000",
    "crop_id": "541f6f98736d61d975720000",
    "user_id": "541f6f98736d61d975730000",
    "stages": [

    ],
    "requirements": [

    ],
    "name": "Just 1 pixel.",
    "overview": "A tiny pixel test image.",
    "featured_image": "http://s3.amazonaws.com/openfarm-rick/test/media/guides/featured_images/541f6f98736d61d975740000.jpg?1411346328"
  }
}
```

# PUT /api/guides/541f6f98736d61d975800000

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
    "_id": "541f6f98736d61d975800000",
    "crop_id": "541f6f98736d61d9757f0000",
    "user_id": "541f6f98736d61d9757e0000",
    "stages": [

    ],
    "requirements": [

    ],
    "name": "teal Swaniawski",
    "overview": "updated",
    "featured_image": "http://openfarm.cc/img/page.png"
  }
}
```

# GET /api/guides/541f6f98736d61d9758b0000

## Params
```
{
}
```

## Response
```
{
  "guide": {
    "_id": "541f6f98736d61d9758b0000",
    "crop_id": "541f6f98736d61d9758a0000",
    "user_id": "541f6f98736d61d9758c0000",
    "stages": [

    ],
    "requirements": [

    ],
    "name": "maroon Krajcik",
    "overview": "In aut dolore itaque illum repudiandae et ipsum.",
    "featured_image": "http://openfarm.cc/img/page.png"
  }
}
```
