
# Zadanie:


## Zistiť z dát, ktoré platby predstavujú mzdy a nájsť ďalšie hlavné kategórie pre platby 


```python

# Importovanie knižníc

import datetime
import pandas as pd
import numpy as np
import warnings
warnings.filterwarnings('ignore')

```


```python

# Načítanie dát a označenie jednotlivých stĺpcov

data = pd.read_table('data_for_applicants.txt', header = None, 
                     names = ['date', 'client', 'amount', 'sender'])

```


```python

# ukážka načítaných dát

data.head()

```




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>date</th>
      <th>client</th>
      <th>amount</th>
      <th>sender</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2014-09-12</td>
      <td>651959088</td>
      <td>6686</td>
      <td>627986531</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2014-09-17</td>
      <td>725866593</td>
      <td>14462</td>
      <td>222382928</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2014-09-12</td>
      <td>313567829</td>
      <td>9965</td>
      <td>222382928</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2014-09-12</td>
      <td>855015364</td>
      <td>10835</td>
      <td>222382928</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2014-09-03</td>
      <td>414606140</td>
      <td>18320</td>
      <td>222382928</td>
    </tr>
  </tbody>
</table>
</div>



* **date** --  dátum

* **client**  -- id klienta

* **amount**  -- výška platby

* **sender**  -- id odosielateľa

### 1. Operácia

* Stanovenie minimálnej mzdy. V roku 2014 bola minimálna mzda v ČR 8500 korún

* Vyselektovanie dát do premennej **df**, ktorá bude obsahovať všetky platby vyššie ako minimálna mzda 


```python

min_mzda = 8500

# data frame - df, ktorý  obsahuje všetky platby vyššie ako minimálna mzda

df = data[ data['amount'] > min_mzda ]

```

### 2. Operácia

* Konvertovanie dátumov z formátu rok-mesiac-deň na rok-mesiac. Časový úsek bude obsahovať iba 6 kategórii (mesiacov), čo mi uľahčí hľadanie výplat (výplatu hodnotím ako pravidelnú platbu, ktora bola klientovi pripísaná na účet každý mesiac aspoň od jedného odosielateľa) <br/> <br/>

* Vytvorenie nového stĺpca, ktorý bude obsahovať spojené id klienta a id odosieteľa. Vytvorím tak jedninečné id páry medzi klientom a odosielateľom, ktoré mi pomôžu pri vyselektovaní výplat (napr. ak sa budú id páry nachádzať v každom mesiaci) <br/> <br/> 

* Následné vytvorenie nových premenných s unikátnymi hodnotami dátumov a spojených id párov, ktoré vložím do **for loop** cyklu. Cieľ cyklu je získanie iba takých id párov, ktoré sa nachádzajú v každom mesiaci. Výsledné id páry mi pomôžu vyselektovať len takých klientov, ktorí dostávajú platby každý mesiac vyššie ako minimálna mzda. 


```python

# formátovanie dátumov

date = pd.to_datetime( df['date'] )
df['date'] = date.dt.strftime('%Y-%m')

# vytvorenie nového stĺpca ('join_id'), ktorý bude obsahovať id páry medzi klientom a odosielateľom

df['join_id'] = df.client.map(str) + df.sender.map(str)

# vytvorene premenných, ktoré obsahujú unikátne dátumy a spojené id páry

months = set(df['date'])
id = set(df['join_id'])

# cyklus, ktorého cieľom je nájsť všetky id páry nachádzajúce sa v každom mesiaci

for m in months:
    month = df[ df['date'] == m ]
    id = id.intersection(month['join_id']) 
    
    
# pohľad na id páry

print(list(id)[0:5])

```

    ['814910129838639938', '821357916674455418', '132302670356081381', '893860660559111653', '592384784308204383']


### 3. Operácia

* Použitie id párov, ktoré sa nachádzajú v každom mesiaci z premennej **id** na vyselektovanie klientov, odosielateľov, platieb a dátumov z **df** do premennej **stable_income** <br/> <br/>

* Následne sa vytvorí nová premenná **client_senders**, ktorá obsahuje počty jedinečných odosielateľov pre kažďeho klienta. Táto premenná sa použije na vyselektovanie klientov, ktorý majú len jedného odosielateľa (**one_sender**) alebo viacerých odosielateľov (**multi_sender**), ktorý im posielajú platby každý mesiac s hodnotou vyššou ako je minimálna mzda.


```python

# vyselektovanie dát z df podľa id párov z premennej 'id'

stable_income = df[ df['join_id'].isin(id) ]

# vytvorenie premennej, ktoré obsahuje počty unikátnych odosielateľov pre každého klienta

client_senders = stable_income.groupby('client')['sender'].nunique()

# premenná, ktorá obsahuje id klientov len s jedným odosielateľom  

one_sender = client_senders[ client_senders == 1 ].index

# premenná s id klientov, ktorý dostávajú platby od viacerých odosielateľov

multi_sender = client_senders[ client_senders > 1 ].index

```

### Tabuľka početnosti odosielateľov, ktorý posielajú peniaze rôznemu počtu klientov každý mesiac


```python

# na ľavo je počet klientov a na pravo počet unikátnych odosieľov pre daný počet klientov

client_senders.value_counts()

# napr. '3' riadok z výstupu znamená, že 103 unikátnych odosielateľov posiela každý mesiac platby trom rôznym klientom
```




    1     15033
    2      1808
    3       103
    4         2
    11        1
    Name: sender, dtype: int64



### 4. Operácia

* Výber dvoch podmnožín z dát **stable_income** na základe id klientov z premenných **one_sender** a **multi_sender**. <br/> <br/>

* Dostanem výsledné dve podmnožiny dát s klientami, ktorým každý mesiac posiela platby len jeden odosielateľ (**income_one_sender**) a podmnožinu klientov s viacerými odosielateľmi (**income_multi_sender**), ktorí im každý mesiac posielajú platby prevyšujúce minimálnu mzdu.


```python

# prvá podmnožina obsahuje klientov z jedným odosielateľom 

income_one_sender = stable_income[ stable_income['client'].isin(one_sender) ]

# druhá podmnožina obsahuje klientov, ktorí dostávajú platby od viacerých odosielateľov

income_multi_sender = stable_income[ stable_income['client'].isin(multi_sender) ]

```

### Pohľad na podmnožiny klientov s jedným a s viacerými odosielateľmi 


```python

# prvá podmnožina je zoradená podľa id klientov a dátumov, obsahuje klienov s jedným odosielateľom

income_one_sender.sort(['client', 'date']).head(12)

```




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>date</th>
      <th>client</th>
      <th>amount</th>
      <th>sender</th>
      <th>join_id</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>105145</th>
      <td>2014-04</td>
      <td>56847</td>
      <td>11432</td>
      <td>222382928</td>
      <td>56847222382928</td>
    </tr>
    <tr>
      <th>102734</th>
      <td>2014-05</td>
      <td>56847</td>
      <td>11437</td>
      <td>222382928</td>
      <td>56847222382928</td>
    </tr>
    <tr>
      <th>99788</th>
      <td>2014-06</td>
      <td>56847</td>
      <td>11434</td>
      <td>222382928</td>
      <td>56847222382928</td>
    </tr>
    <tr>
      <th>96986</th>
      <td>2014-07</td>
      <td>56847</td>
      <td>11434</td>
      <td>222382928</td>
      <td>56847222382928</td>
    </tr>
    <tr>
      <th>94791</th>
      <td>2014-08</td>
      <td>56847</td>
      <td>11339</td>
      <td>222382928</td>
      <td>56847222382928</td>
    </tr>
    <tr>
      <th>91341</th>
      <td>2014-09</td>
      <td>56847</td>
      <td>11371</td>
      <td>222382928</td>
      <td>56847222382928</td>
    </tr>
    <tr>
      <th>69484</th>
      <td>2014-04</td>
      <td>61441</td>
      <td>17032</td>
      <td>547166056</td>
      <td>61441547166056</td>
    </tr>
    <tr>
      <th>68814</th>
      <td>2014-05</td>
      <td>61441</td>
      <td>45773</td>
      <td>547166056</td>
      <td>61441547166056</td>
    </tr>
    <tr>
      <th>65786</th>
      <td>2014-06</td>
      <td>61441</td>
      <td>17821</td>
      <td>547166056</td>
      <td>61441547166056</td>
    </tr>
    <tr>
      <th>62836</th>
      <td>2014-07</td>
      <td>61441</td>
      <td>17445</td>
      <td>547166056</td>
      <td>61441547166056</td>
    </tr>
    <tr>
      <th>57598</th>
      <td>2014-08</td>
      <td>61441</td>
      <td>25562</td>
      <td>547166056</td>
      <td>61441547166056</td>
    </tr>
    <tr>
      <th>56965</th>
      <td>2014-09</td>
      <td>61441</td>
      <td>17459</td>
      <td>547166056</td>
      <td>61441547166056</td>
    </tr>
  </tbody>
</table>
</div>




```python

# druhá podmnožina obsahuje klientov s viacerými odosielateľmi

income_multi_sender.sort(['client', 'date']).head(12)

```




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>date</th>
      <th>client</th>
      <th>amount</th>
      <th>sender</th>
      <th>join_id</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>70642</th>
      <td>2014-04</td>
      <td>450431</td>
      <td>12704</td>
      <td>219047249</td>
      <td>450431219047249</td>
    </tr>
    <tr>
      <th>327953</th>
      <td>2014-04</td>
      <td>450431</td>
      <td>14748</td>
      <td>633236581</td>
      <td>450431633236581</td>
    </tr>
    <tr>
      <th>327954</th>
      <td>2014-04</td>
      <td>450431</td>
      <td>16117</td>
      <td>633236581</td>
      <td>450431633236581</td>
    </tr>
    <tr>
      <th>68106</th>
      <td>2014-05</td>
      <td>450431</td>
      <td>12704</td>
      <td>219047249</td>
      <td>450431219047249</td>
    </tr>
    <tr>
      <th>326953</th>
      <td>2014-05</td>
      <td>450431</td>
      <td>15095</td>
      <td>633236581</td>
      <td>450431633236581</td>
    </tr>
    <tr>
      <th>326954</th>
      <td>2014-05</td>
      <td>450431</td>
      <td>16359</td>
      <td>633236581</td>
      <td>450431633236581</td>
    </tr>
    <tr>
      <th>65081</th>
      <td>2014-06</td>
      <td>450431</td>
      <td>12706</td>
      <td>219047249</td>
      <td>450431219047249</td>
    </tr>
    <tr>
      <th>326077</th>
      <td>2014-06</td>
      <td>450431</td>
      <td>12842</td>
      <td>633236581</td>
      <td>450431633236581</td>
    </tr>
    <tr>
      <th>326078</th>
      <td>2014-06</td>
      <td>450431</td>
      <td>16303</td>
      <td>633236581</td>
      <td>450431633236581</td>
    </tr>
    <tr>
      <th>62153</th>
      <td>2014-07</td>
      <td>450431</td>
      <td>12779</td>
      <td>219047249</td>
      <td>450431219047249</td>
    </tr>
    <tr>
      <th>325128</th>
      <td>2014-07</td>
      <td>450431</td>
      <td>12214</td>
      <td>633236581</td>
      <td>450431633236581</td>
    </tr>
    <tr>
      <th>325129</th>
      <td>2014-07</td>
      <td>450431</td>
      <td>16009</td>
      <td>633236581</td>
      <td>450431633236581</td>
    </tr>
  </tbody>
</table>
</div>



### 5. Operácia

* Vytvorenie zvyšnej podmnožiny dát kde sa nachádzajú klienti, ktorí nedostávajú každý mesiac príjem vyšší ako je minimálna mzda <br/> <br/>

* Zvyšnú množinu (**unstable_income**) dostanem z **df** kde sa nachádzajú všetky platby vyššie ako minimálna mzda. Použijem predchádzajúce podmnožíny **income_one_sender** a **income_multi_sender** na vytvorenie novej podmnožiny **income_all**, ktorá bude obsahovať spoločné indexy predchádzajúcih podmnožín <br/> <br/>

* Indexy z **income_all** použijem na vyselektovanie zvyšnej podmnožiny **unstable_income**, ktorá bude obsahovať indexy len z **df** a zároveň nebude mať žiadny index z **income_all** 


```python
income_all = pd.concat([income_one_sender, income_multi_sender], axis=0)

unstable_income = df[~ df.index.isin(income_all.index)]

```


```python
unstable_income.sort(['client', 'date']).head(14)
```




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>date</th>
      <th>client</th>
      <th>amount</th>
      <th>sender</th>
      <th>join_id</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>285509</th>
      <td>2014-04</td>
      <td>61441</td>
      <td>15346</td>
      <td>45437871</td>
      <td>6144145437871</td>
    </tr>
    <tr>
      <th>243911</th>
      <td>2014-05</td>
      <td>61441</td>
      <td>9703</td>
      <td>762490320</td>
      <td>61441762490320</td>
    </tr>
    <tr>
      <th>243104</th>
      <td>2014-06</td>
      <td>61441</td>
      <td>8875</td>
      <td>762490320</td>
      <td>61441762490320</td>
    </tr>
    <tr>
      <th>240922</th>
      <td>2014-08</td>
      <td>61441</td>
      <td>11008</td>
      <td>762490320</td>
      <td>61441762490320</td>
    </tr>
    <tr>
      <th>397989</th>
      <td>2014-04</td>
      <td>72755</td>
      <td>9981</td>
      <td>566495527</td>
      <td>72755566495527</td>
    </tr>
    <tr>
      <th>54286</th>
      <td>2014-04</td>
      <td>78274</td>
      <td>68655</td>
      <td>482592832</td>
      <td>78274482592832</td>
    </tr>
    <tr>
      <th>104502</th>
      <td>2014-04</td>
      <td>87884</td>
      <td>21397</td>
      <td>222382928</td>
      <td>87884222382928</td>
    </tr>
    <tr>
      <th>48037</th>
      <td>2014-06</td>
      <td>106137</td>
      <td>10301</td>
      <td>627986531</td>
      <td>106137627986531</td>
    </tr>
    <tr>
      <th>45180</th>
      <td>2014-07</td>
      <td>106137</td>
      <td>11864</td>
      <td>627986531</td>
      <td>106137627986531</td>
    </tr>
    <tr>
      <th>40155</th>
      <td>2014-08</td>
      <td>106137</td>
      <td>25278</td>
      <td>345882789</td>
      <td>106137345882789</td>
    </tr>
    <tr>
      <th>40156</th>
      <td>2014-08</td>
      <td>106137</td>
      <td>12263</td>
      <td>627986531</td>
      <td>106137627986531</td>
    </tr>
    <tr>
      <th>39536</th>
      <td>2014-09</td>
      <td>106137</td>
      <td>12161</td>
      <td>627986531</td>
      <td>106137627986531</td>
    </tr>
    <tr>
      <th>248309</th>
      <td>2014-05</td>
      <td>155840</td>
      <td>14066</td>
      <td>745087094</td>
      <td>155840745087094</td>
    </tr>
    <tr>
      <th>180008</th>
      <td>2014-09</td>
      <td>184477</td>
      <td>219466</td>
      <td>329355591</td>
      <td>184477329355591</td>
    </tr>
  </tbody>
</table>
</div>


