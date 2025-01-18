##### **Create subdivisions of scripts based on each step of the html file. Then I need to explain how the github is structured in this readme, and move the text that is currently in this readme. Finally link all the images, genomes, etc that I used that are too big to push to github.




his is the first commit of the project.


Early answers for part 2 (Quality Checks) of workflow

### **How many reads do we have per sample?**
Each sampe has 6 reads. This is because there are 3 replicates of each sample, and each sample has two reads one forward and reverse read. 3*2 = 6 

### **How does the average base quality change along the length of the reads, and between mates 1 and 2?**
HER21_R1: avg goes from 38 to 34, with extreme outliers down to 2. 
HER21_R2: slightly better, still goes from 38 to 34 with utliers of 2, but less at 34. However, the cuve is less regular. 

HER22_R1: from 37 to 33, outliers down to 2. 
HER22_R2: from 36 to 32, outlier to 2

HER23_R1: from 38 to 34, outliers to 25. Best quality
HER23_R2: from 38 to 34, outliers to 2. 
---------------------------------
NonTNBC1_R1: from 38 to 34, outliers to 2. Best quality
NonTNBC1_R2: from 38 to 34, outliers to 2. 

NonTNBC2_R1: No box on plot until position 40. now whiskers until position 14. Huge range of values. whiskers range from 34-2
NonTNBC2_R2: No box until position 32. Better than R1. whiskers range from 34-2

NonTNBC3_R1: No whiskers until pos 7. No boxes until pos 37. whiskers range from 34-2
NonTNBC3_R2: No bboxes until pos 27. whiskers range from 34-2
---------------------------------
TNBC1_R1: avg consistent at 34 entire sequence. whiskers from 38 to 15. Probably best
TNBC1_R2: avg consistent at 34 entire sequence. whiskers from 38 to 2

TNBC2_R1: avg consistent at 34 entire sequence. whiskers from 38 to 2
TNBC2_R2: avg from 34 to 33 entire sequence. whiskers from 38 to 2

TNBC3_R1: avg from 36 to 34 entire sequence. whiskers from 38 to 2
TNBC3_R2: avg from 35 to 34 entire sequence. whiskers from 38 to 2
---------------------------------
Normal1_R1: Parabolic shape. avg 34 to 41 to 34. whiskers 41 to 2
Normal1_R2: Parabolic shape. avg 33 to 41 to 34. whiskers 41 to 2

Normal2_R1: Parabolic shape. avg 34 to 41 to 34. whiskers 41 to 2
Normal2_R2: Parabolic shape. avg 33 to 41 to 35. whiskers 41 to 2


Normal3_R1: Parabolic shape. avg 34 to 41 to 35. whiskers 41 to 2
Normal3_R2: Parabolic shape. avg 33 to 41 to 35. whiskers 41 to 17. Probably best
### **Is there evidence of adapter sequences?**

HER samples: very very little evidence of adapter sequences. least of all samples

Non TNBC samples: very minimal evidence of adapter sequences

TNBC samples: minimal evidence of adapter sequences. Particularly in R2's and TNBC3 sample

Normal samples: No evidence of adapter sequences.


### **Do you spot any issues that need to be addressed before you continue with the analysis?**

HER: High amount of duplicated sequences. Remaining % of seqs if deduplicated is between 29-39%. GC content could also be an issues

Non TNBC: High amount of duplicated sequences. Remaining % of seqs if deduplicated is between 31-38%.  Per base sequence content is an issue in all samples. GC content is an issue from some samples. 

TNBC: Per base sequence content. Sequence duplication levels for some samples. overrepresented sequences in some samples.

Normal: Per base sequence content. Sequence duplication levels in some samples.

# SIDE NOTE: I TRIMMED and/or filtered the original fastq files with fastp, and then performed QC on those. INterestingly, according to the multi qc report, it almost seems that the quality of these fastp reads are worse#

There are 2 workfflows I have right now. COmpletely raw, where I didnt perform and trimming or filtering on the fastq, and no deduplicating. There is a second one i am working on right now, denoted by the prefix fastp_ that i performed fastp on and deduplicated with samtools rmdup.

## **PART 3**

### **What are the alignment rates observed across samples?**
### **What is concordant alignment and how many reads are concordantly aligned in the different samples?**
### **Is there evidence of multimapped reads? If so, is this a concern for downstream analyses?**