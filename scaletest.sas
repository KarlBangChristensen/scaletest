%macro scaletest(	data, 
					items, 
					ncat, 
					name=scaletest,
					type=SPERMAN,
					GROUP=NONE);

**************************************************************************

data: the data set
items: list of items
ncat: number of response categories for items
name: name for output
type=SPEARMAN (currently the only option)

GROUP-option: currently not implemented (ranges)

**************************************************************************
;

options nosymbolgen nomprint nomlogic nonotes nostimer ls=130 ps=55;

ods exclude all;

********************************************** 
save number of respondents as macro variable 
**********************************************
;
%put ncat=&ncat;
data _nm;
	set &data;
	nm=nmiss(of &items);
run;
data _nm;
	set _nm;
	if nm=0;
run;
data _null_;
	set _nm end=final;
 	if final then call symput('N',trim(left(_N_)));
run;

**********************************************
save item names as macro variables 
**********************************************
;
data _null_;
	set &data;
 	array _y (*) &items;
 	length name $20;
 	if _n_=1 then do;
  		do _i=1 to dim(_y);
   			call vname(_y{_i},name);
   			call symput('_item'||trim(left(put(_i,4.))),trim(left(name)));
  		end;
  		_p=dim(_y); 
  		call symput('_nitems', trim(left(put(_p,4.))));
 	end;
run;

**********************************************
frequency tables 
**********************************************
;
proc freq data=&data; 
	tables &items; 
	%do _i=1 %to &_nitems; 
		ods output Table&_i..OneWayFreqs=_table&_i; 
	%end;
run;
%do _i=1 %to &_nitems;
	proc transpose data=_table&_i(keep=percent) out=_table&_i; 
	run;
	data _table&_i; 
		set _table&_i; 
		name='                                                   '; 
		name="&&_item&_i"; 
		drop _NAME_; 
	run;
%end;

**********************************************
item means
**********************************************
;
%do _i=1 %to &_nitems;
	proc sql; 
		select mean(&&_item&_i), std(&&_item&_i)
		into :_mean, :_SD
		from &data;
	run;
	data _table&_i; 
		set _table&_i; 
		mean=&_mean; 
		SD=&_SD; 
		format mean SD 8.2;
		label mean='Mean';
	run;
%end;

**********************************************
inter-item correlations and Cronbachs alpha 
**********************************************
;
proc corr data=&data alpha nomiss; 
	var &items; 
	ods output corr.cronbachalphadel=_ad;
	ods output corr.cronbachalpha=_a;
run;
proc corr data=&data spearman; 
	var &items;
	ods output corr.spearmancorr=_c;
run;

%do _i=1 %to &_nitems;
	proc sql; 
		select min(&&_item&_i), max(&&_item&_i) 
		into :_min, :_max 
		from _c 
		where Variable ne "&&_item&_i"; 
	quit;
	data _table&_i; set _table&_i; _min=&_min; _max=&_max; run;
%end;

**********************************************
item-total correlations 
**********************************************
;
data __;
	set &data;
	total=sum(of &items);
run;
proc corr data=__ spearman; 
	var total;
	with &items;
	ods output corr.spearmancorr=_itemtotal;
run;
data _itemtotal;
	set _itemtotal;
	rename Variable=Item;
	drop Ptotal Ntotal;
run;

**********************************************
print results
**********************************************
;
data _table; 	
	set _table1-_table&&_nitems; 
	floor=COL1; ceiling=COL&ncat; 
	drop COL1-COL&ncat;
	format _min _max 8.2 floor ceiling 8.1;
run;
data &name;
	merge _table _itemtotal;
	label name='Item' _min='range of inter' _max='item corr.' total='Corr. with total';
	format total 8.2;
run;

ods exclude none;

title "&name: (&_nitems items, &N persons)"; 
proc print data=&name noobs label; 
run;

options notes stimer;
title ' ';
%mend scaletest;
