#COUNT#

select count(*)
from (select distinct ph.[No_],rwal.[Whse_ Activity No_],rwah.[Picking Tare ID] from 
[Shate-M$Posted Whse_Shipment Header SW] as ph
left join [Shate-M$Posted Whse_ Shipment Line SW] as pw on pw.[No_] = ph.[No_]
left join [Shate-M$Registered Whse_ Activity Line] as rwal on rwal.[Whse_ Document No_] = ph.[Whse_ Shipment No_]
  and pw.[Item No_] = rwal.[Item No_]     and rwal.[Whse_ Document Line No_] = pw.[Whse Shipment Line No_] and [Action Type] = 1
left join [Shate-M$Registered Whse_ Activity Hdr_] as rwah on rwah.[No_] = rwal.[No_]   
where ph.[Posting Date] >= CONVERT ( datetime ,'20130707', 112)
and ph.[Posting Date] <= CONVERT ( datetime ,'20130707', 112)
) as tab

#MAIN#

select 
tm.[Trade Mark Name], 
it.[No_ 2],
tab.cur,
it.[Description],
iif(len(ig2.[Description]) < 1 , ig1.[Description],ig2.[Description]), 
ig1.[Description],
it.[Item Comment],
(it.[No_ 2] + '_' + tm.[Trade Mark Name]),
tab.[st],
it.[Sales Order Multiple],
(iig.[Item Group Code]+'$'+iig.[Item Group Type Code]),
(iig2.[Item Group Code]+'$'+iig2.[Item Group Type Code]),
iif(COALESCE(iig3.[Item Group Code],'Õ≈“') = 'Õ≈“',0,1),
it.[Part ID]
from [#DB#$Item Group] as ig
join [#DB#$Item Item Group] as iig  on iig.[Item Group Code] = ig.code
      and iig.[Phantom Item] = 0 and iig.[Item Group Type Code] = '“Œ¬À»Õ»ﬂ'
join [#DB#$Item] as it on it.[No_] = iig.[Item No_]
left join [tm] on tm.[Trade Mark Code] = it.[TM Code]
join [#DB#$Item Group] as ig1 on ig1.[nodeid] = ig.[parentid]
join [#DB#$Item Group] as ig2 on ig2.[nodeid] = ig1.[parentid]
join [#DB#$Item Item Group] as iig2  on iig2.[Item No_] = it.[No_]
      and iig2.[Item Group Type Code] = '“Ã'
left join [#DB#$Item Item Group] as iig3  on iig3.[Item No_] = it.[No_]
      and iig3.[Item Group Type Code] = '—œ≈÷«¿ ¿«'

left join (select sp.[Item No_],(sp.[Unit Price]/COALESCE(
(
Select top 1 [Exchange Rate Amount] from [#DB#$Currency Exchange Rate] as cer
  where cer.[Currency Code] = sp.[Currency Code]
  and (CONVERT (nchar , sp.[Starting Date], 112) <= '#DateStart#')  
  order by [Starting Date] desc),1)
) as cur,
iif(sp.[Allow Line Disc_] = 0,1,0) as st, sp.[Minimum Quantity],sp.[Unit of Measure Code]
from [#DB#$Serv_ Prog_ Integration Setup] as spis
left join [#DB#$Sales Price] as sp 
join [#DB#$Item] as it1 on it1.[No_] = sp.[Item No_]
on sp.[Sales Code] = spis.[Customer Price Group Code] 
 and (
   (
   CONVERT (nchar , sp.[Ending Date], 112) >= '#DateEnd#')
   or(CONVERT ( nchar , sp.[Ending Date], 112) = '17530101')
  ) and (CONVERT (nchar , sp.[Starting Date], 112) <= '#DateStart#')
  where sp.[Minimum Quantity] <= it1.[Sales Order Multiple] and (sp.[Unit of Measure Code] = it1.[Sales Unit of Measure]  or sp.[Unit of Measure Code] = '') 
     
)as tab on tab.[Item No_] =  it.[No_]    
where ig.[Export to Service Program] = 1
      and ig.[Item Group Type Code] = '“Œ¬À»Õ»ﬂ' 
      and ig.code = '#No#'       
order by it.[No_]
	
#PREPARE#

select ig_old.code as cd
from [#DB#$Item Group] as ig_old
where [Export to Service Program] = 1
          and [Item Group Type Code] = '“Œ¬À»Õ»ﬂ'
           and code > ''
                and (select top 1 [Item Group Code] from [#DB#$Item Item Group] as ts_data
                        where ts_data.[Item Group Code] = ig_old.code
                        and ts_data.[Phantom Item] = 0 and ts_data.[Item Group Type Code] = '“Œ¬À»Õ»ﬂ'
                        ) is not null
order by cd
