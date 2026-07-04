proc import datafile="&raw" out=work.raw dbms=csv replace; getnames=yes; guessingrows=max; run;
