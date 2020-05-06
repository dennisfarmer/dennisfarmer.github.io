---
title: "Analyzing Factors of Academic Success"
date: 2020-05-05
tags: [python, pandas]
header:
  image: "/projectimages/FOAS/header.jpg"
excerpt: "Using Pandas to find correlations between student traits and academics"
mathjax: "true"
---

_Full code can be accessed at the [Github repository](https://github.com/dennisfarmer/Factors-of-Academic-Success)_

[Part I: Cleaning](#part-i-data-cleaning-and-transformation)

[Part II: Analysis and Visualization](#part-ii-exploratory-data-analysis-and-visualization)

When thinking of a beginner project idea to practice my new data analysis skills, I went right to the process of college admissions, and how grades and personal essays are used to determine the chances of being admitted. Lots of effort is put into students' academic lives in order to acquire the skills necessary for their future career lives.
 

It would be beneficial to these students to find ways of improving performance at school. Finding the correlations between numerous traits and grades will allow students to pinpoint things that may be either holding them back, or things that they should incorporate into their lives to improve their level of academic achievement.

### Data Source:

A Google Forms Survey was used to allow students to opt-in to providing their academic and personal qualities information. This survey can be previewed and/or taken [here](https://forms.gle/2AM9BPv56zsQCNc1A).



|TIMESTAMP        |SURVEY_LOCATION|AGE|GENDER|MAJOR       |SCHOOL    |SCHOOL_YEAR|HS_GPA|COLLEGE_GPA|SAT |ACT|IQ |ACTIVITIES           |NUM_HOBBIES|WATCHED_MEDIA                                                                                                                                                                                                                                                                        |MUSIC_GENRE|FAV_MUSIC_ARTISTS|FAV_COLOR|FAV_COMP_COLOR|SELF_IMPROV                                                                                                                                                                                                                                                                                                                                                            |GO_TO_BED |UP_FROM_BED|OPENNESS|CONSCIENTIOUSNESS|EXTRAVERSION|AGREEABLENESS|NEUROTICISM|MYERS_BRIGGS|RELIGION    |SOCIAL_AWKWARD|SOCIAL_ANXIOUS|SHOW_UP_EARLY|CLUTTERED|DEPRESSED|SHARE_POSTS_OFTEN|
|-----------------|----------|---|------|------------|----------|-----------|------|-----------|----|---|---|---------------------|-----------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------|-----------------|---------|--------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|-----------|--------|-----------------|------------|-------------|-----------|------------|------------|--------------|--------------|-------------|---------|---------|-----------------|
|3/4/2020 11:49:53|TEST     |18 |Male  |Data Science|University|Freshman   |3.5   |3.75       |1350|   |   |Indoor Drumline / WGI|5          |Blade Runner (1982), Ferris Bueller's Day Off (1986), ...|  |                 |         |              |I take cold showers, I try to limit my use of social media, ...|9:59:59 PM|6:00:00 AM |8       |8                |2           |10           |8          |INFJ        |Nonreligious|Yes           |No            |No           |Yes      |No       |No               |


[Back To Top](#top)
# Part I: Data Cleaning and Transformation

```python
import pandas as pd
import numpy as np
import datetime as dt
import re
```

We will only cover the interesting pieces of the data cleaning process for brevity purposes. The Github repo contains the full code.

### Importing the dataset from multiple spreadsheet files

```python
import os

os.chdir("Google Forms Surveys")

for _, _, filenames in os.walk(os.getcwd()):
        surveydata = read_data(filenames[0])
        for f in filenames[1:]:
            surveydata = pd.merge(left=surveydata, right=pd.read_excel(f), how="outer")
        break

surveydata.columns = map(str.lower, dataframe.columns)
```

### Calculating Hours of Sleep

Included in the survey data are the average times that students go to bed and wake up from bed. To find the number of hours between these two times, we can use the `datetime` python library to calculate the difference of the two times. 

```python
def time_to_datetime(dt_series):
    """
    Converts dt.time values to dt.datetime values based on the bedtime or waketime
    Accepts dt.time Series
    Returns dt.datetime Series
    """
    dt_series.reset_index(drop=True, inplace=True)
    
    # Insert date
    time_day = pd.Series(["1970/01/02 " 
                          if (dt_series.name == 'up_from_bed' or (dt_series.name == 'go_to_bed' and dt_series[i]).hour <= 5) 
                          else "1970/01/01 " 
                          for i in range(dt_series.shape[0])]).astype(str)

    # Convert time values to strings
    time_time = dt_series.astype(str)

    # Concat date and time and convert to datetime object    
    return (time_day + time_time).apply(lambda x: dt.datetime.strptime(x, "%Y/%m/%d %H:%M:%S"))
```

We will need to clean some of the data, as some participants did not select the correct AM/PM selection.

```python
### Calculate the average amount of sleep for each person
def clean_bed_times(dt_series):
    """
    Corrects incorrect AM/PM selection for given column name
    Accepts dt.time Series
    Returns dt.time Series
    """
    if dt_series.name == "go_to_bed":
        return pd.Series([dt.time(np.abs(time.hour - 12), time.minute, 0) 
                        if 6 < time.hour < 18 
                        else time 
                        for time in dt_series])
    
    elif dt_series.name == "up_from_bed":
        return pd.Series([dt.time(np.abs(time.hour - 12), time.minute, 0) 
                        if time.hour > 18 
                        else time 
                        for time in dt_series])
    
surveydata["go_to_bed"], surveydata["up_from_bed"] = clean_bed_times(surveydata["go_to_bed"]), clean_bed_times(surveydata["up_from_bed"])


# Calculate and insert column into the dataset and convert timedelta to hours
surveydata.insert(23, 'avg_sleep_hours', (time_to_datetime(surveydata['up_from_bed']) - time_to_datetime(surveydata['go_to_bed'])).apply(lambda x: x.seconds / 3600))

```



### Expanding Dense Cells into Individual Cells

Multiple choice questions in Google Forms compress every answer each participant gives into a single cell in the spreadsheet.

To remedy this, we can write a function that creates unique columns in the Pandas dataframe for each unique element in a column of lists, commonly refered to as a **dummy variable**.

```python
def make_dummies(series, astype=float):

    unique_elements = []
    series = series.fillna("")
    clean_str = lambda x: x.strip().lower().replace(' ', '_')

    # Create a list of unique values throughout all cells in column
    for row in series:
        unique_elements.extend([clean_str(element) for element in row if clean_str(element) not in unique_elements])

    def create_bool_series(cell, unique):
        for element in cell:
            if unique == clean_str(element):
                return True
            else:
                pass
        return False
        
    dataframe = pd.DataFrame()

    for u in unique_elements:
        dataframe.insert(0, u, series.apply(lambda x: create_bool_series(x, unique=u)), allow_duplicates=True)

    return dataframe[dataframe.columns.tolist()[::-1]].astype(astype)
```
We will transform each cell from a single string into a list of strings before feeding each series into our new `make_dummies` function.
```python
columns = ['self_improv', 'activities', 'watched_media']
surveydata[columns] = surveydata[columns].apply(lambda x: x.str.split(","))

for column in columns:
    surveydata = pd.concat([surveydata, make_dummies(surveydata[column], astype=float)], axis=1)

surveydata = surveydata.drop(columns, axis=1)
```
### Dropping Unpopular Survey Questions

![Unpopular Survey Questions](/projectimages/FOAS/UnpopularQuestions.png "Man's Search For Meaning is pretty great btw")

An important aspect to take note of for the duration of this project is the relatively low sample size of the survey. If only ~10% of the participants respond to a question, it is likely that their responses are not representitave of the entire population of students.

```python
surveydata = surveydata.drop(['nofap','theater','gaming_club','stem_club','diary','flow:_the_psychology_of_optimal_experience_by_mihaly', 'mr._robot', 'eternal_sunshine_of_the_spotless_mind_(2004)', "man's_search_for_meaning_by_viktor_frankl", 'self-reliance_by_ralph_waldo_emerson'], axis=1)
```
### Exporting the Data to .CSV Format

```python
def export_data(df, path:'path/to/folder_name'='.', fname='data', ftype=['.csv'], set_index:'column_name'=None, mute_output=False):
    
    if not os.path.exists(path):
        os.mkdir(path)
    
    root_dir = os.getcwd()
    os.chdir(path)
    out_names = []
    
    dataframe = df.copy()
    if set_index:
        dataframe.set_index(set_index, inplace=True)

    if '.csv' in ftype:
        dataframe.to_csv(f"{fname}.csv")
        out_names.append(f"{fname}.csv")
        
    if not mute_output:
        print(f'''The following file{"s have" if len(out_names) > 1 else " has"} been saved to "{os.getcwd()}"\n''', str(out_names).replace("'","").replace("[","").replace("]",""), '\n', sep="")
    os.chdir(root_dir)
    
export_data(surveydata, fname='surveydata', ftype='.csv', set_index='timestamp')
```
```
The following file has been saved to "/home/dennisfarmer/Github/Factors-of-Academic-Success"
surveydata.csv
```
[Back To Top](#top)
# Part II: Exploratory Data Analysis and Visualization
