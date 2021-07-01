# scaletest
SAS macro and R function to compute simple descriptive statistics for scale validation.

The current implementation works for item sets where all items are scored 0,1,..,MAX (same maximum score for all items in the set). For items where, e.g., only 0,1,2, and 4 have been observed the ceiling will not be correct.

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
