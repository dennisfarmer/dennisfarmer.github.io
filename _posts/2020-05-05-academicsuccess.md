---
title: "Analyzing Factors of Academic Success"
date: 2020-05-05
tags: [python, pandas]
header:
  image: "/projectimages/FOAS/header.jpg"
excerpt: "Using Pandas to find correlations between student traits and academics"
mathjax: "true"
---

<em>Full code can be accessed at the <a href="https://github.com/dennisfarmer/Factors-of-Academic-Success" target="_blank">Github repository</a></em>



[Part I: Data Cleaning](#part-i-data-cleaning)

[Part II: Data Transformation](#part-ii-data-transformation) 

[Part III: Data Analysis and Visualization](#part-iii-data-analysis-and-visualization)

When coming up with a beginner project idea to practice my new data analysis skills, I thought about the process of college admissions, and how grades and personal essays are used to determine the chances of being admitted. Lots of effort is put into students' academic lives in order to acquire the skills necessary for their future career lives.
 

It would be beneficial to these students to find ways of improving performance at school. Finding the correlations between numerous traits and grades will allow students to pinpoint things that may be either holding them back, or things that they should incorporate into their lives to improve their level of academic achievement.

### Data Source:

A Google Forms Survey was used to allow students to opt-in to providing their academic and personal qualities information. This survey can be previewed and/or taken <a href="https://forms.gle/2AM9BPv56zsQCNc1A" target="_blank">here</a>.


|TIMESTAMP        |SURVEY_LOCATION|AGE|GENDER|MAJOR       |SCHOOL    |SCHOOL_YEAR|HS_GPA|COLLEGE_GPA|SAT |ACT|IQ |ACTIVITIES           |NUM_HOBBIES|WATCHED_MEDIA                                                                                                                                                                                                                                                                        |MUSIC_GENRE|FAV_MUSIC_ARTISTS|FAV_COLOR|FAV_COMP_COLOR|SELF_IMPROV                                                                                                                                                                                                                                                                                                                                                            |GO_TO_BED |UP_FROM_BED|OPENNESS|CONSCIENTIOUSNESS|EXTRAVERSION|AGREEABLENESS|NEUROTICISM|MYERS_BRIGGS|RELIGION    |SOCIAL_AWKWARD|SOCIAL_ANXIOUS|SHOW_UP_EARLY|CLUTTERED|DEPRESSED|SHARE_POSTS_OFTEN|
|-----------------|----------|---|------|------------|----------|-----------|------|-----------|----|---|---|---------------------|-----------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------|-----------------|---------|--------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|-----------|--------|-----------------|------------|-------------|-----------|------------|------------|--------------|--------------|-------------|---------|---------|-----------------|
|3/4/2020 11:49:53|TEST     |18 |Male  |Data Science|University|Freshman   |3.5   |3.75       |1350|   |   |Indoor Drumline / WGI|5          |Blade Runner (1982), Ferris Bueller's Day Off (1986), ...|  |                 |         |              |I take cold showers, I try to limit my use of social media, ...|9:59:59 PM|6:00:00 AM |8       |8                |2           |10           |8          |INFJ        |Nonreligious|Yes           |No            |No           |Yes      |No       |No               |

<hr>
[Back To Top](#top)
# Part I: Data Cleaning

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

Multiple answer questions in Google Forms compress every answer each participant gives into a single cell in the spreadsheet.

To remedy this, we can write a function that creates unique columns in the Pandas dataframe for each unique element in a column of lists, commonly refered to as **dummy variables**.

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

An important aspect to take note of for the duration of this project is the relatively low sample size of the survey. If only ~10% of the participants responded to a question, it is likely that their responses are not representitave of the entire population of students.

```python
surveydata = surveydata.drop(['nofap','theater','gaming_club','stem_club','diary','flow:_the_psychology_of_optimal_experience_by_mihaly', 'mr._robot', 'eternal_sunshine_of_the_spotless_mind_(2004)', "man's_search_for_meaning_by_viktor_frankl", 'self-reliance_by_ralph_waldo_emerson'], axis=1)
```
### Exporting the Data to .CSV Format

```python
# Function from my modules
export_data(surveydata, fname='surveydata', ftype='.csv', set_index='timestamp')
```
```
The following file has been saved to "/home/dennisfarmer/Github/Factors-of-Academic-Success"
surveydata.csv
```
<hr>
[Back To Top](#top)
# Part II: Data Transformation

```python
surveydata = pd.read_csv("surveydata.csv")
surveydata.set_index("timestamp", inplace=True)
```

<a href="https://github.com/dennisfarmer/Factors-of-Academic-Success/blob/master/surveydata.csv" target="_blank">Link to surveydata.csv file</a>

### Intelligence Score
To create a more concise method for determining academic success, we will formulate an "Intelligence Score" for each participant, which will take a weighted average of the `hs_gpa`, `college_gpa`, and `converted_sat` columns compared with the average value for each respective column.

To calculate weights for `hs_gpa`, `college_gpa`, and `converted_sat`, we can incorporate the statistical mean for each value. Since the `college_gpa` mean score is lower than the `hs_gpa` mean grade, we can conclude that getting a high GPA in college is more challenging than getting a high GPA in high school. Therefore, each score in the calculation should be weighed based on its relative difficulty, as seen in the table below:

|Column|Mean|Mean / 400|Calculation|Weight|
|:-----|---:|---------:|----------:|-----:|
|`hs_gpa`|3.655||4 - Mean|0.344|
|`college_gpa`|3.403||4 - Mean|0.596|
|`converted_sat`|1294|3.235|4 - (Mean / 400)|0.764|

If a number is missing, we can insert the average score for that value, then reweigh the missing column. If an  existing score is higher than its average, the percentage difference will be subtracted from the inserted value's weight. Likewise, if a student is below average in a specific score, the inserted value's weight will increase.

```
# Pseudocode:

for student_score in [existing_scores]:
    deltaweight = (student_score / average_score) - 1
    missing_value_weight = missing_value_weight - deltaweight
```

After all of the weights are adjusted for missing values, we will then use the weighted mean formula to calculate an intelligence score.

\\[\textrm{I Score} = \frac{w_{h}s_{h} + w_{c}s_{c} + w_{s}s_{s}}{w_{h}+w_{c}+w_{s}}\\]

```python
def calc_intelligence(grades:"[floatHs, floatCollege, floatSat]", avgs:"[floatHs, floatCollege, floatSat]"):
    """
    Reduces a student's hard work throughout all of 
    high school and university down to a single number.
    """
    weights = [4-avgs[0], 4-avgs[1], 4-(avgs[2]/400)]
    
    ### Correct for missing values:
    # Stores the index of missing values, with non-missing values being recorded as '-1'
    missing_index = [i if pd.isnull(grades[i]) else -1 for i in range(3)]
    for missing in missing_index:
        if missing == -1:
            continue
            # ^ if a score is not missing, continue to the next score
            
        # Insert the average grade to replace the missing value
        grades[missing] = avgs[missing]
        
        # Adjust weight for missing value based on if each non-missing
        # value is greater or less than its corresponding mean
        for notmiss in range(3):
            if missing_index[notmiss] == -1:
                weights[missing] -= (grades[notmiss] / avgs[notmiss]) - 1
        
        if weights[missing] < 0:
            weights[missing] = 0
    
    # Convert SAT score to be out of 4 (instead of 1600)
    grades[2] /= 400
    
    # Apply corresponding weights to each grade
    weighted_grades = [grades[i] * weights[i] for i in range(3)] 
    
    # Calculate intelligence score using weighted mean formula
    intelligence_score = sum(weighted_grades) / sum(weights)
    return intelligence_score
```
```python
averages = [surveydata.hs_gpa.mean(), surveydata.college_gpa.mean(), surveydata.converted_sat.mean()]

i_scores = [calc_intelligence(listGrades, averages) 
            for listGrades in surveydata[["hs_gpa", "college_gpa", "converted_sat"]].values]

surveydata.insert(14, "i_score", i_scores)

export_data(surveydata['i_score'], fname='i_score_values', ftype='.csv')
```
```
The following file has been saved to "/home/dennisfarmer/Github/Factors-of-Academic-Success"
i_score_values.csv
```

![Intelligence Score Compared to Student Metrics](/projectimages/FOAS/AI_bplot_scores.png)

### Favorite Music Artists

To analyze the `fav_music_artists` column and its correlation with `i_score`, we can split up each artist into its own column and insert either a `1` or `0` depending on if each participant listed each artist as one of their favorites.

```python
fav_music_artists = make_dummies(surveydata.fav_music_artists.fillna("").apply(lambda x: x.split(",")),astype=int)

agg_fav_music_artists = fav_music_artists.sum().sort_values(ascending=False)
```
```
# agg_fav_music_artists:
                         count:                        count:
[blank] ------------------ 8  melanie_martinez --------- 2 
queen -------------------- 4  luke_combs --------------- 2
jacob_collier ------------ 3  radiohead ---------------- 2       
taylor_swift ------------- 3  electric_light_orchestra - 2   
the_beatles -------------- 3  imagine_dragons ---------- 2   
post_malone -------------- 2  tennyson ----------------- 2   
kendrick_lamar ----------- 2  childish_gambino --------- 2   
paramore ----------------- 2  nirvana ------------------ 2
the_red_hot_chili_peppers  2  jonas_brothers ----------- 2
stone_temple_pilots ------ 2  ...
tame_impala -------------- 2  [113_other_artists] ------ 1
```

Plotting the above data would lead to a massive number of bars in our chart, with many of the bars having the same width. This is because for the vast majority of artists, only a single person listed them as one of their favorites.

We can combine this data with similar data from the `chosen_music_artists` column, then filter to only include artists with a  frequency of two or greater. This will allow us to keep a wide range of different artists from the dataset.

```python
def combine_duplicate_columns(df, column_names, suffix):
    dataframe = df.copy()
    for column in column_names:
        try:
            dataframe[column] = dataframe[[column, column+suffix]].any(axis=1)
            dataframe = dataframe.drop([column+suffix], axis=1)
        except KeyError:
            continue
    return dataframe
```
```python
chosen_music_artists = make_dummies(surveydata.chosen_music_artists
                                    .fillna("").apply(lambda x: x.split(",")),
                                    astype=int)

music_artists = chosen_music_artists.join(fav_music_artists, how="left", rsuffix="2")

music_artists = combine_duplicate_columns(music_artists, chosen_music_artists.columns, "2")

music_artists = music_artists[np.unique(
    chosen_music_artists.columns.to_list() 
    + fav_music_artists.sum()[fav_music_artists.sum() > 1].index.to_list()
                                       )]
```
![Music Artist Frequency](/projectimages/FOAS/MA_frequency_allmusicartists.png)

If these results were being put to meaningful use, we would drop the artists with a low frequency to improve accuracy, based on the total number of people who took the survey.

To order the musical artists in the dataset by average `i_score`, we can write a function that accumulates the average `i_score` for each artist by indexing the dataset with the music artist boolean columns.

```python
def get_avg_i_scores(dataframe, dummy, i_col='i_score'):
    dummy = dummy.astype(bool)
    avg_scores = {}
    for col in dummy.columns:
        avg_scores[col] = dataframe.loc[dummy[col],i_col].sum() / dummy[col].sum()
    return pd.Series(avg_scores)
```
<hr>
[Back To Top](#top)
# Part III: Data Analysis and Visualization

### Distribution of Grades

![Distribution of Grades](/projectimages/FOAS/INTRO_gradedistribution.png)

As expected, College GPAs are slightly lower on average than High School GPAs, with equivalent SAT scores placing lower than both. The average SAT scores have a bell curve that is quite narrow in contrast with the two GPA datapoints. This might be due to the fact that few people score a 1600 on the SAT, while it is rather unrare to see high school and college students with 4.0 GPAs.


### Music Artists

![Music Artists and Their Fan's Average Academic Success](/projectimages/FOAS/FOAS_MusicArtists.png)

It is surprising that seemingly "big brain" bands like Radiohead and Beethoven lay close to the average for the dataset, as opposed to being higher in the list. This is likely due to the low frequency of each artist in general leading to randomness in the mean values, however I would have expected bands like The Beatles and Billy Joel to be higher due to their "before-our-time"-ness. To make our data more accurate, we could just plot the artists with freq > 2, but that would not leave us with a lot of remaining data to work with.

Frank Zappa leading the intelligence pack makes sense, since he is a percussionist (why else?). Panic(!) at The Disco being at the bottom of the intellectual food chain is likely a result of their frequency being equal to only two.

### Sleep Analysis

![Bed/Wake Time and Academic Success](/projectimages/FOAS/FOAS_corr_bedwake_iscore.png)

![Amount of Sleep and Academic Success](/projectimages/FOAS/FOAS_AmountOfSleep.png)

A lack of clear correlation between healthy sleep patterns and academic success likely means that sleep patterns are not able to  make or break your academic life. There is a rather faint v-shape trend on the bed/wake time plot (drawn above), but when considering the dispersion of the dataset, this trend is not very significant.

### Self-Development Methods

![Correlations between Self-Development Methods and Academic Success](/projectimages/FOAS/FOAS_SelfDevelopment.png)

```
                  Average I Score
Limit Social Media -- 3.468
Diet ---------------- 3.458
Exercise ------------ 3.440
Journal ------------- 3.435
Meditation ---------- 3.421
Cold Showers -------- 3.401
Morning Routine ----- 3.399

[Average] ----------- 3.395

Energy Drinks ------- 3.376
Coffee -------------- 3.376
```
The general conclusion is that some of these traits can indeed give an outline to determine a student's academic success. Correlations do exist, between both `i_score` and between different methods on the matrix. Although the actual numeric differences between `i_score` values for each of the self improvement methods is negligible, most of our results do make sense from an intuitive standpoint.

Beyond academics, there are some consistant trends across the correlation matrix: 

- Coffee drinkers are less likely to participate in any of the other methods (besides using energy drinks). Unfortunately, this abnormally strong trend is more likely than not because of a low sample size, because only 6 participants responded as being coffee drinkers (the question was added late). 

- People who limit their use of social media are statistically likely to also participate in most of the methods on this matrix, and are unlikely to participate in the activities that negatively correlate with `i-score`. If you are looking for a way to get into the methods on the matrix, looking into limiting your social media usage is a great way to start.

- Students who meditate are likely to also keep a journal, and those who exercise are also likely to maintain a healthy diet. These traits go hand-in-hand as being focused on mind and body respectively, which is interesting to notice alongside the fact that these two sets of traits do not necessarily have a strong correlation with each other, meaning that students who journal and meditate don't really have a higher or lower chance of dieting and exercising.

#### Coffee vs Energy Drinks
<h6>(This is the best plot I could come up with for these, sue me for my terrible graphs lol)</h6>

![Coffee vs Energy Drink](/projectimages/FOAS/PD_coffeeVSenergy_iscore.png)

One of the more surprising conclusions is that being a coffee drinker turns out to negatively impact your grades more than being an energy drink user. As well as this, neither of these drinks are correlated with *higher* grades (on average), rather the effect of energy drinks is close to zero and coffee has a negative correlation of -0.38. You would think that drinking coffee would increase your brain's clarity or something, but according to the data, the inverse is true.

The combination of coffee and energy drinks impacts academic achievement by a non-marginal amount. Sample size is still something to consider with this data, but at the same time the clear difference between categories is quite interesting to observe.

Overall, the idea to draw from this is that caffeine is bad for your brain. That doesn't really stop me from drinking it, but statistically speaking, you should **not** drink it. :)

#### Mind vs Body Focused Methods

![Correlation Between Mind and Body](/projectimages/FOAS/SD_corr_mindvsbody.png)

![Mind vs Body Focused](/projectimages/FOAS/PD_mindVSbody_iscore.png)

Comparing mind and body focused methods and their effect on `i_score` shows us that incorporating either one tends to correlate with better academics, with a synergy effect when both methods are used.

### Myers-Briggs Letters



# Summary
You may notice a common theme of issues arising from having an insufficient sample size. With this format of project (small-scale web survey), 
