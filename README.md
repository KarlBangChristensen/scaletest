# scaletest
SAS macro and R function to compute simple descriptive statistics for scale validation.

The current implementation works for item sets where all items are scored 0,1,..,MAX (same maximum score for all items in the set). For items where, e.g., only 0,1,2, and 4 have been observed the ceiling will not be correct.

Call the SAS macro using

```
%scaletest(data=homep.ears, items=item1-item6, ncat=5, type=SPERMAN);
```
