---
title: "Exploring the GitHub API"
date: 3020-05-14

[comment]: # (tags: [python, api])

permalink: /exploring-github-api/
header:
  image: "/projectimages/GH_API/header.jpg"
excerpt: "Interacting with an API using Python and CMD"
mathjax: "true"
---


```python
import requests
import json
import pandas as pd
import re
```


```python
access_token = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
headers = {"Authorization":f"token {access_token}"}
```

### GET Request for User Info
```python
response = requests.get("https://api.github.com/user", headers=headers)
user_info = response.json()
print(response.status_code)

>> 200
```
```python
user_info

>>
{'login': 'dennisfarmer',
     'id': 56651870,
     'node_id': 'MDQ6VXNlcjU2NjUxODcw',
     'avatar_url': 'https://avatars2.githubusercontent.com/u/56651870?v=4',
     'gravatar_id': '',
     'url': 'https://api.github.com/users/dennisfarmer',
     ...
}
```

### GET Request for User Repositories
```python
response = requests.get("https://api.github.com/user/repos", headers=headers)
user_repos = response.json()
print(response.status_code)

>> 200
```
```python
user_repos[2]

>>
{'id': 242766797,
     'node_id': 'MDEwOlJlcG9zaXRvcnkyNDI3NjY3OTc=',
     'name': 'Factors-of-Academic-Success',
     'full_name': 'dennisfarmer/Factors-of-Academic-Success',
     ...
     'default_branch': 'master',
     'permissions': {'admin': True, 'push': True, 'pull': True}}
```

```python
foas = pd.read_json(json.dumps(user_repos[2]))
foas.head(1)
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>id</th>
      <th>node_id</th>
      <th>name</th>
      <th>full_name</th>
      <th>private</th>
      <th>owner</th>
      <th>html_url</th>
      <th>description</th>
      <th>fork</th>
      <th>url</th>
      <th>...</th>
      <th>mirror_url</th>
      <th>archived</th>
      <th>disabled</th>
      <th>open_issues_count</th>
      <th>license</th>
      <th>forks</th>
      <th>open_issues</th>
      <th>watchers</th>
      <th>default_branch</th>
      <th>permissions</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>login</th>
      <td>242766797</td>
      <td>MDEwOlJlcG9zaXRvcnkyNDI3NjY3OTc=</td>
      <td>Factors-of-Academic-Success</td>
      <td>dennisfarmer/Factors-of-Academic-Success</td>
      <td>False</td>
      <td>dennisfarmer</td>
      <td>https://github.com/dennisfarmer/Factors-of-Aca...</td>
      <td>Data analysis project to find coorelations bet...</td>
      <td>False</td>
      <td>https://api.github.com/repos/dennisfarmer/Fact...</td>
      <td>...</td>
      <td>NaN</td>
      <td>False</td>
      <td>False</td>
      <td>0</td>
      <td>NaN</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>master</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
<p>1 rows × 74 columns</p>
</div>




```python
user_repos[2]['url']

>> 'https://api.github.com/repos/dennisfarmer/Factors-of-Academic-Success'
```

# Update Repository Description:

_**Old:**_
- _"Data analysis project to find coorelations between strong academics and personal interests/traits in students"_

_**New:**_
- _"Using Pandas to find correlations between student traits and academics"_


### PATCH Request to Update Repo Description
```python
payload = {"description": "Using Pandas to find correlations between student traits and academics"}
response = requests.patch("https://api.github.com/repos/dennisfarmer/Factors-of-Academic-Success", json=payload, headers=headers)
print(response.status_code)

>> 200
```

```python
response.json()['description']

>> 'Using Pandas to find correlations between student traits and academics'
```

# Exploring other API Endpoints:


```python
response = requests.get("https://api.github.com/users/dennisfarmer")
endpoints = response.json()
endpoints

>>
{'login': 'dennisfarmer',
     'id': 56651870,
     'node_id': 'MDQ6VXNlcjU2NjUxODcw',
     'avatar_url': 'https://avatars2.githubusercontent.com/u/56651870?v=4',
     'gravatar_id': '',
     'url': 'https://api.github.com/users/dennisfarmer',
     'html_url': 'https://github.com/dennisfarmer',
     'followers_url': 'https://api.github.com/users/dennisfarmer/followers',
     'following_url': 'https://api.github.com/users/dennisfarmer/following{/other_user}',
     'gists_url': 'https://api.github.com/users/dennisfarmer/gists{/gist_id}',
     'starred_url': 'https://api.github.com/users/dennisfarmer/starred{/owner}{/repo}',
     'subscriptions_url': 'https://api.github.com/users/dennisfarmer/subscriptions',
     'organizations_url': 'https://api.github.com/users/dennisfarmer/orgs',
     'repos_url': 'https://api.github.com/users/dennisfarmer/repos',
     'events_url': 'https://api.github.com/users/dennisfarmer/events{/privacy}',
     'received_events_url': 'https://api.github.com/users/dennisfarmer/received_events',
     ...
}
```

### `following_url`
```python
endpoints["following_url"]

>> 'https://api.github.com/users/dennisfarmer/following{/other_user}'
```

```python
re.match(r"([^{]+)", endpoints["following_url"])[0]

>> 'https://api.github.com/users/dennisfarmer/following'
```

### GET Request for Users Following
```python
response = requests.get(re.match(r"([^{]+)", endpoints["following_url"])[0], 
                        headers=headers)
user_following = response.json()
print(response.status_code)

>> 200
```


```python
for user in user_following:
    print(user['login'])
    
>>
chrishwiggins
PlayingNumbers
```

```python
user_following[0]['login'] == 'chrishwiggins'

>> True
```

```python
avatar_url = user_following[0]["avatar_url"]
avatar_url

>> 'https://avatars3.githubusercontent.com/u/310196?v=4'
```

**PYTHON:**
```python
from IPython.display import Image
from IPython.core.display import HTML

Image(url=avatar_url)
```

![](/projectimages/GH_API/310196.jpg)



**MARKDOWN:** 

`![](https://avatars3.githubusercontent.com/u/310196?v=4)`

![](/projectimages/GH_API/310196.jpg)


```python
Image(url=endpoints['avatar_url'])
```


![](/projectimages/GH_API/56651870.jpg)


# File Reading:

### GET Request for User Info
```zsh
!curl -H "Authorization: token XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" https://api.github.com/user
```

```json
{
    "login": "dennisfarmer",
    "id": 56651870,
    "node_id": "MDQ6VXNlcjU2NjUxODcw",
    ...
}
```
### Create `request.json`

```zsh
!curl -H "Authorization: token XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" https://api.github.com/user > request.json
```

      % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                     Dload  Upload   Total   Spent    Left  Speed
    100  1586  100  1586    0     0   6608      0 --:--:-- --:--:-- --:--:--  6608

### Open `request.json` with Python

```python
with open('request.json', 'r') as json_file:
    data = json.load(json_file)
```


```json
{
    "login": "dennisfarmer",
    "id": 56651870,
    "node_id": "MDQ6VXNlcjU2NjUxODcw",
    ...
}
```


### Pipe GET Request to Command Line Python Tool


```zsh
!curl -H "Authorization: token XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" https://api.github.com/user | python -m json.tool
```

      % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                     Dload  Upload   Total   Spent    Left  Speed
    100  1586  100  1586    0     0   6580      0 --:--:-- --:--:-- --:--:--  6580
    
```json    
{
    "login": "dennisfarmer",
    "id": 56651870,
    "node_id": "MDQ6VXNlcjU2NjUxODcw",
    ...
}
```
