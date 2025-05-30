# scaletest
SAS macro and R function to compute simple descriptive statistics for scale validation.

The current implementation works for item sets where all items are scored 0,1,..,MAX (same maximum score for all items in the set). For items where, e.g., only 0,1,2, and 4 have been observed the ceiling will not be correct.

## SAS macro

Call the SAS macro using

```
%scaletest(data=homep.ears, items=item1-item6, ncat=5, type=SPERMAN);
```

here you can specify

- `data`
- `items`
- `ncat`
- `name` the name of the output data set (default value: scaletest)
- `type` the type of correlation (values `SPEARMAN`, `PEARSON`, ..)

the output looks like this:

| Item  | Mean | SD   | range of inter | item corr. | floor | ceiling | Item  | Corr. with total |
|-------|------|------|----------------|------------|-------|---------|-------|------------------|
| item1 | 3.55 | 0.78 | 0.36           | 0.61       | 1.6   | 67.4    | item1 | 0.65             |
| item2 | 2.17 | 1.51 | 0.26           | 0.60       | 17.5  | 35.1    | item2 | 0.76             |
| item3 | 1.96 | 1.51 | 0.22           | 0.60       | 21.5  | 29.2    | item3 | 0.79             |
| item4 | 3.60 | 0.76 | 0.22           | 0.50       | 1.0   | 72.8    | item4 | 0.53             |
| item5 | 3.20 | 1.36 | 0.36           | 0.46       | 9.8   | 70.6    | item5 | 0.72             |
| item6 | 3.49 | 0.93 | 0.32           | 0.61       | 3.6   | .       | item6 | 0.66             |

so for, say, `item2` the Spearman rank correlations with the five other items range from 0.26 to 0.60 and the correlation with the total score is 0.76. Note that for `item6` no `ceiling` is reported this is because the marginal distribution looks like this

| item6 | Frequency | Percent |
|-------|----------:|--------:|
| 0     | 7         | 3.59    |
| 1     | 0         | 0.00    |
| 2     | 18        | 9.23    |
| 3     | 36        | 18.46   |
| 4     | 134       | 68.72   |

## R function

Use

```
source("https://raw.githubusercontent.com/KarlBangChristensen/scaletest/refs/heads/master/scaletest.R")
SPADI <- read.csv("https://erda.ku.dk/public/archives/bacc560d26b01f7a65e77a9712a92e86/SPADI.csv")
items <- SPADI[, c("P1", "P2", "P3", "P4", "P5")]
table scaletest(data = items, min_item_score = 0, max_item_score = 5)  
```

this generates the output `table` that looks like this: 

|    | mean     | sd       | floor      | ceiling   | min       | mac       | item_score_corr | raw_corr   |
|----|----------|----------|------------|-----------|-----------|-----------|-----------------|------------|
| P1 | 3.596491 | 1.072026 | 0.4385965  | 19.298246 | 0.4825197 | 0.5584445 | 0.7134621       | 0.5980698  |
| P2 | 3.137168 | 1.399600 | 4.8672566  | 16.371681 | 0.4958951 | 0.5537464 | 0.7674607       | 0.6282480  |
| P3 | 3.133333 | 1.423652 | 7.5555556  | 14.666667 | 0.5434118 | 0.7680526 | 0.8520359       | 0.7530783  |
| P4 | 2.535088 | 1.551920 | 13.5964912 | 8.771930  | 0.4825197 | 0.7680526 | 0.8593796       | 0.7520765  |
| P5 | 2.500000 | 1.515109 | 13.7168142 | 6.637168  | 0.4958951 | 0.5898980 | 0.7925418       | 0.6513641  |

Note that (i) `floor` and `ceiling` are reported as percentages, (ii) for each item the correlations with the four other items range between `min` and `mac`, (iii) `raw_corr` is the so-called corrected item-total correlation (correlation between an item and the sum of all other items in the scale).
