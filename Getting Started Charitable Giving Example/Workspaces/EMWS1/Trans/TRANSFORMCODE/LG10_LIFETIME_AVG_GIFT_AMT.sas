label LG10_LIFETIME_AVG_GIFT_AMT = 'Transformed LIFETIME_AVG_GIFT_AMT';
if LIFETIME_AVG_GIFT_AMT eq . then LG10_LIFETIME_AVG_GIFT_AMT = .;
else do;
if LIFETIME_AVG_GIFT_AMT + 1 > 0 then LG10_LIFETIME_AVG_GIFT_AMT = log10(LIFETIME_AVG_GIFT_AMT + 1);
else LG10_LIFETIME_AVG_GIFT_AMT = .;
end;
