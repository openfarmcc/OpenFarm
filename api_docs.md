# API Docs V1
=============

The v1 API uses the JSON-API specifications. We're still migrating to it. Watch this space to keep up to date on it.

## Quirks
* We're overriding the standard name format because both JavaScript and Ruby work better with an `_` than a `-` in names.
This is counter to the [JSON-API recommendation on naming](http://jsonapi.org/recommendations/#naming).
* We're a bit more flexible about PUTing and POSTing data to the API and how it's structured relationship wise. 

## General

The general structure of an API response is (for example, through a GET request):

```
{
    'data': {
        'type': '<object_type>',
        'id': '<object_id>',
        'attributes': {},
        'relationships': {}
    }
}
```
And how you'd send a PATCH, PUT, or POST
```
{
    'data': {
        'type': '<object_type>',
        'id': '<object_id>', // optional for POST
        'attributes': {},
        'images', # Look at section on images
        'relationship_reference_ids', # Ex. crop_id, guide_id, garden_id.
    }
}
```

## Crops

> *Note:* Crops need a filter to return something. There's too many otherwise, and we don't have pagination sorted yet. It's not sure we ever will, as the need for that isn't immediately clear.

### Routes

```
GET api/v1/crops/?filter=<query>
POST api/v1/crops/
GET api/v1/crops/<id>/
PUT api/v1/crops/<id>/
GET api/v1/crops/<id>/pictures/
```

### Returned from server

> ToDo. This is based on the standardized output shown above.

### Send to server
```
{
 'data': {
    'type': 'crops',
    'id': '<id>', # required: PUT
    'attributes': { # required
        'name', # required: POST
        'common_names',
        'binomial_name',
        'description',
        'sun_requirements',
        'sowing_method',
        'spread', # cm
        'days_to_maturity',
        'row_spacing', # cm
        'height' # cm
    }
    'images': [] # TODO: read the section on images. 
}
```

## Guides

### Routes

```
POST api/v1/guides/
GET api/v1/guides/<id>/
PUT api/v1/guides/<id>/
GET api/v1/guides/<id>/stages/
```

### Returned from server

```
{
    'data': {
        'type': 'guides',
        'id': '<id>', 
        'attributes': { 
            'name', 
            'overview',
            'featured_image': {
                'image_url',
                'thumbnail_url'
            }
            'location',
            'practices', 
            'compatibility_score', # read only
            'basic_needs', # read only
            'completeness_score', # read only
            'popularity_score', # read only
        },
        'relationships': {
            'crop',
            'user',
            'time_span',
            'stages'
    }
}
```

### Send to server
```
{
 'data': {
    'type': 'guides',
    'id': '<id>', # required: PUT
    'attributes': { # required
        'name', # required: POST
        'overview',
        'featured_image',
        'location',
        'practices', # Array [String]
        'time_span': {
            'start_event',
            'start_event_format',
            'start_offset',
            'start_offset_amount',
            'length',
            'length_units',
            'end_event',
            'end_event_format',
            'end_offset_units',
            'end_offset_amount'
        }
    }
    'crop_id': # Either `crop_id` or `crop_name` is required.
    'crop_name': # Either `crop_id` or `crop_name` is required.
}
```
## Stages

### Routes

```
GET /api/v1/guide/<guide_id>/stages/
POST /api/v1/stages/
GET /api/v1/stages/<id>/
DELETE /api/v1/stages/<id>/
```

### Returned from server

```
{
    'data': {
        'type': 'stages',
        'id': '<id>', 
        'attributes': { 
            'name', 
            'soil',
            'environment',
            'light',
            'order', 
            'stage_length',
        },
        'relationships': {
            'guide',
            'pictures',
            'time_span',
            'stage_actions'
    }
}
```

### Send to server

```
{
    'data': {
        'type': 'stages',
        'id': '<id>' # PUT required,
        'attributes': {
            'name', # PUT required
            'order', # PUT required
            'environment',
            'soil',
            'light',
            'stage_length'
        },
        'guide_id',
        'actions',
        'images', [] # TODO: read the section on images
    }
}

## Gardens

> Note: To get a specific user's gardens, use `/api/v1/users/<id>/gardens/`

### Routes

```
POST api/v1/gardens/
GET api/v1/gardens/<id>/
PUT api/v1/gardens/<id>/
```

### Returned from server

> ToDo

### Send to server
```
{
 'data': {
    'type': 'gardens',
    'id': '<id>', # required: PUT
    'attributes': { # required
        'name', # required: POST
        'location',
        'description',
        'type',
        'average_sun',
        'soil_type',
        'is_private', # Boolean # cm
        'ph', # Float
        'growing_practices', # Array [String]    
    }
    'images': [] # TODO: Read the section on images.
}
```

## Garden Crops

### Routes

> Note: Garden crops aren't directly accessible - you have to go through the route of their garden. See above.

```
GET api/v1/gardens/<garden_id>/garden_crops/
POST api/v1/gardens/<garden_id>/garden_crops/
GET api/v1/gardens/<garden_id>/garden_crops/<id>/
PUT api/v1/gardens/<garden_id>/garden_crops/<id>/
```

### Returned from server

> ToDo

### Send to server

You have to send this via the gardens endpoint. 
```
{
 'data': {
    'type': 'garden-crops',
    'id': '<id>', # required: PUT
    'attributes': { # required
        'quantity',
        'guide', # POST only, Guide id
        'crop', # POST only, Crop id
        'stage', # String
        'sowed', # Date
    }
}
```

## Users

### Routes

```
GET api/v1/users/<id>/
PUT api/v1/users/<id>/
GET api/v1/users/<id>/gardens/
```

Users can't be created (yet) throught the API.

### Returned from server

> ToDo

### Send to server
```
{
 'data': {
    'type': 'users',
    'id': '<id>', # required: PUT
    'attributes': { # required
        'display_name',
        'mailing_list',
        'help_list',
        'is_private',
    },
    'user_setting': {
        'location',
        'years_experience',
        'units',
        'favorite_crop'
    },
    'featured_image': # TODO describe
}
```

## Detail Options

Detail Options can only be fetched.

### Routes

```
GET /api/v1/detail_options/
```

### Returned from server

> ToDo

## Stage Action Options

Stage Action Options can only be fetched.

### Routes

```
GET /api/v1/stage_action_options/
```

### Returned from server

> ToDo

## Stage Options

Stage Options can only be fetched.

### Routes

```
GET /api/v1/stage_options/
```

### Returned from server

> ToDo

## Tokens

### Routes

```
DELETE /api/v1/token/
```
> Note: You must be logged in to perform this action. No parameters are required. This is a log out action, essentially.


```
POST /api/v1/token/
```

Send
```
{ 'data':
    {
      "email": "manuel@treutel.org",
      "password": "password"
    }
}
```

Response
```
{ 'data': 
      "token": {
        "expiration": "2014-11-29T11:53:10.537Z",
        "secret": "manuel@treutel.org:ca80cf3f7e66166bc37af0e4d56146fd"
      }
}
```

> Note: Hit this API endpoint to generate an authentication token. Take the token that it returns and insert it as a request header like so: `Authorization: Token token=YOUR_TOKEN_HERE`


## Errors

Errors are returned of the form:

```
{
    'errors': [
        {'title': 'Error Title'},
        ...
    ]
}
```

--------------

