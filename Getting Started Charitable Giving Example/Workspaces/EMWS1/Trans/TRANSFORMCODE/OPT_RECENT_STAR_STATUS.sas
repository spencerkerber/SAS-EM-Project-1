label OPT_RECENT_STAR_STATUS = 'Transformed RECENT_STAR_STATUS';
length OPT_RECENT_STAR_STATUS $36;
if (RECENT_STAR_STATUS eq .) then OPT_RECENT_STAR_STATUS="01:low-0.5, MISSING";
else
if (RECENT_STAR_STATUS < 0.5) then
OPT_RECENT_STAR_STATUS = "01:low-0.5, MISSING";
else
if (RECENT_STAR_STATUS >= 0.5 and RECENT_STAR_STATUS < 1.5) then
OPT_RECENT_STAR_STATUS = "02:0.5-1.5";
else
if (RECENT_STAR_STATUS >= 1.5) then
OPT_RECENT_STAR_STATUS = "03:1.5-high";
