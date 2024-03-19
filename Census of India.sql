select*
from CensusProject.dbo.Data1

select*
from CensusProject.dbo.Data2

---No of rows into our dataset
select count(*)from CensusProject..Data1
select count(*)from CensusProject..Data2

---Dataset for Bihar and Jharkhand
select*
from CensusProject..Data1
where state in ('Bihar','Jharkhand')

---Population of India 
select sum(population) as Population
from CensusProject..Data2

---Average growth
select state, avg(growth)*100 as AvgGrowth from CensusProject..Data1 group by State;

--Average sex ratio
select state, round(avg(Sex_Ratio),0) as AvgSexRatio from CensusProject..Data1 group by state order by AvgSexRatio desc;

---Average Literacy rate
select state, round(avg(Literacy),0) as AvgLiteracyRate from CensusProject..Data1 group by state order by AvgLiteracyRate desc;

---Average Literacy rate greater than 80
select state,round(avg(literacy),0) AvgLiteracyRate from CensusProject..Data1
group by state having round(avg(literacy),0)>80 order by AvgLiteracyRate desc;

---Top 3 states showing heighest growth ratio
select top 3 state, avg(growth)*100 as AvgGrowth from CensusProject..Data1 group by State order by AvgGrowth desc;

---Bottom 3 states showing lowest sex ratio
select top 3 state, round(avg(Sex_Ratio),0) as AvgSexRatio from CensusProject..Data1 group by state order by AvgSexRatio asc;

---Top and bottom 3 states in literacy  state

drop table if exists TopStates;
create table TopStates
(state nvarchar(255),
	TopStates float
	)

insert into TopStates
select state, round(avg(Literacy),0) as AvgLiteracyRate from CensusProject..Data1 group by state order by AvgLiteracyRate desc;

select top 3*
from TopStates 
order by TopStates.TopStates desc;


drop table if exists BottomStates;
create table BottomStates
(state nvarchar(255),
	BottomStates float
	)

insert into BottomStates
select state, round(avg(Literacy),0) as AvgLiteracyRate from CensusProject..Data1 group by state order by AvgLiteracyRate desc;

select Top 3*
from BottomStates
order by BottomStates.BottomStates asc;


---Union Operator
select* from(
select top 3*
from TopStates 
order by TopStates.TopStates desc)a

union

select* from(
select Top 3*
from BottomStates 
order by BottomStates.BottomStates asc)b

---Filtering States starting with letter a

select state
from CensusProject..Data2
where lower(state) like 'a%' or lower(state) like ('b%')

select state
from CensusProject..Data2
where lower(state) like 'a%' and lower(state) like ('%m')

---Joining both Table

select a.District,a.State,a.Sex_Ratio/1000 sex_ratio,b.population from CensusProject..Data1 a inner join CensusProject..Data2 b on a.District = b.District



---Total Literacy rate

select c.state,sum(literacy_people) total_literate_pop,sum(illitrate_people) total_ilitrate_pop from
(select d.district,d.state,round(d.literacy*d.population,0) literacy_people,round((1-d.literacy)*d.population,0) illitrate_people from
(select a.district,a.state,a.Literacy/100 literacy,b.population from CensusProject..Data1 a inner join CensusProject..Data2 b on a.district=b.district) d)c
group by c.state

---window
---output top 3 districts from each states with heighest literacy rate
select a.*from
(select district, state,literacy,rank() over(partition by state order by literacy desc) rank from CensusProject..Data1)a
where a.rank in (1,2,3) order by state

