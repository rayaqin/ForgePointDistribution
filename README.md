<h1>Forge Point Distribution</h1>
<br>
<h3>Feladat:</h3>
<p>
A model a Forge of Empires játék egy gyakori problémáját hivatott megoldani. A játékos rendelkezik adott mennyiségű Forge Point-tal <i>(FP)</i>, amelyet szét szeretne osztani optimálisan a rendelkezésre álló Great Building-ek <i>(GB)</i> között. Ha egy GB szintet lép, akkor a szintlépéshez hozzájáruló játékosok jutalmakat kapnak attól függően, hogy milyen helyezést értek el. A helyezés attól függ, hogy mennyi FP-t fektettek az építkezésbe a többi befektetőhöz képest <i>(egyenlő befektetett pont esetén az "nyer", aki hamarabb rakta be az utolsó pontját)</i>. Annál magasabb a jutalom, minél jobb helyezést ér el a játékos, és minél magasabb szintű az épület, illetve minden GB-nél különbözőek az értékek. A jutalom értékét százalékosan növeli a játékos Arc GB-je, annak szintjétől függően. Például egy 80-as szintű Arc 1.9-es szorzót jelent a jutalomra. 
</p>

<h4>Egy GB-hez az alábbi adatok tartoznak:</h4>
<i>(több GB is megadható, ez esetben a model elosztja a játékos FP-it optimálisan a GB-k között)</i>

<ol>
<li>Hány FP szükséges a következő szint eléréséhez. </li>
<li>Hány FP-t, Blueprintet <i>(BP)</i>, Medált adnak az egyes pozíciók </li>
<li>Az első 5 pozícióra elhelyezett pontok </li>
<li>Hány FP-t fektettek összesen a jelenlegi szintbe</li>
</ol>

<h4>Játékosunkhoz tartozó adatok:</h4>

<ol>
<li>Hány FP van a raktárában</li>
<li>Milyen szorzót biztosít az Arc-ja</li>
<br>
</ol>
<p>Maximalizálandó az FP, BP és Medál jutalmakból származó <b>profit</b> <i>(állítható ezek egymáshoz viszonyított prioritása)</i>.</p>
