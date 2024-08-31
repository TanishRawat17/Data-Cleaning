select * from layoffs;



-- STEP 1 : REMOVE DUPLICATES --

CREATE TABLE `layoffs_clean` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


insert into layoffs_clean
select *, row_number() OVER(partition by company, location, industry, total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
from layoffs;


select * from layoffs_clean where row_num >1;

delete from layoffs_clean where row_num >1;


-- STEP 2 : Standardize the Data --

select * from layoffs_clean;

select distinct industry 
from layoffs_clean;

Update layoffs_clean
set company = trim(company);


select distinct industry 
from layoffs_clean;

update layoffs_clean
set industry = 'Crypto'
where industry Like 'Crypto%';


select `date`
from layoffs_dateclean;

Update layoffs_clean
set `date` = str_to_date(`date`,'%m/%d/%Y');

alter table layoffs_clean
modify column `date` date;


select distinct country from layoffs_clean;

update layoffs_clean
set country = 'United State'
where country like 'United States%';


-- STEP 3 : Remove Null and Blank Values --

select * from layoffs_clean;

select * from layoffs_clean
where (total_laid_off is null Or total_laid_off = '')
and percentage_laid_off is null;

delete from layoffs_clean
where (total_laid_off is null Or total_laid_off = '')
and percentage_laid_off is null;


select distinct industry from layoffs_clean;

select * from layoffs_clean
where industry is null or industry = '';

update layoffs_clean 
set industry = null
where industry is null or industry = '';

select * from layoffs_clean l1
join layoffs_clean l2
on l1.company = l2.company and 
l1.location = l2.location
where l1.industry is null and l2.industry is not null;

update layoffs_clean l1
join layoffs_clean l2
on l1.company = l2.company and 
l1.location = l2.location
set l1.industry = l2.industry 
where l1.industry is null and l2.industry is not null;

delete from  layoffs_clean
where industry is null ;


alter table layoffs_clean
drop column row_num;

select * from layoffs_clean;