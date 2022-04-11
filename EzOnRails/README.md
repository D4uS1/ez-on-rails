# EzOnRails
EzOnRails ist eine Sammlung von Generatoren für die einfache Erstellung von Rails-Applikationen,
die hauptsächlich auf Partials basieren. Auf diese Weise wird ein einheitliches Aussehen der Applikation gewährleistet.
Zudem sind die Partials anpasssbar.
Alles ist bereits für mehrsprachige Unterstützung ausgelegt.
Außerdem kann die Applikation mittels Namespaces in Module zu unterteilt werden. Diese Modulstruktur wird dann
in Dashboards und Navigation berücksichtigt. Dies gewährleistet eine ordentliche Sortierung von Quellcode und Daten und macht es für den Nutzer angenehmer sich strukturiert zurecht zu finden.
Zudem wird eine Nutzerverwaltung über Devise mitgeliefert, eine Seite für ein Impressum, eine Datenschutzerklärung und ein Kontaktformular.

Folgende Generatoren sind vorhanden:

* ezapp             - Baut das Grundgerüst der Applikation, inklusive unter Anderem Startseite, Titel und Navigation und Breadcrumbs. Kopiert alles was zu EzApp dazu gehört in die eigene Applikation.
* ezdev             - Erstellt Dateien zum Arbeiten mit Docker, RubyMine und gitlab-ci.
* ezscaff           - Baut eine REST-Ressource (Scaffold), deren actions über Partials gerendert werden, um so ein einheitliches Aussehen zu gewährleisten
* ezform            - Baut ein Formular ohne zugrunde Liegende Datenbankressource. Das Formular wird mit Partials gerendert. Es nutzt ein ActiveModel, sodass die rails Interna für Validierung etc. genutzt werden können.
* ezdash            - Baut ein Dashboard für einen Namespace, welches mit Partials gerendert wird.
* eznav             - Baut anhand der existierenden Routen automatisch eine Navigation auf. Die Navigation wird über ein Partial dargestellt.
* ezapi             - Baut einen API-Controller auf, welcher auch mit einer Resource verbunden werden kann
* ezuser            - Generiert die Benutzer-Model-Klasse inklusive aller Controller, Helper und Views, sodass diese angepasst werden können ohne den Core von EzOnRails anpassen zu müssen.
* ezviews           - Generiert die Views und das Layout von EzOnRails in die Hauptapplikation, sodass diese angepasst werden können, ohne den Core von EzOnRails anpassen zu müssen.
* ezhelpers         - Generiert die Helper, die für das Rendern der Views erforderlich sind in die Hauptapplikation, sodass hier Hilfsmethoden ergänzt werden können
* ezwelcome         - Erstellt die Resourcen für die Willkommensseite, sodass diese angepasst werden kann ohne den EzOnRails Core anzupassen.
* ezcontact         - Erstellt die Resourcen für das Kontaktformular, sodass dieses angepasst werden kann ohne den EzOnRails Core anzupassen.
* ezimprint         - Erstellt die Resourcen für das Impressum, sodass dieses angepasst werden kann ohne den EzOnRails Core anzupassen.
* ezprivacy         - Erstellt die Resourcen für die Datenschutzerklärung, sodass diese angepasst werden kann ohne den EzOnRails Core anzupassen.

## Installation
Für die Installation wird von einer komplett frischen Rails-Applikation ausgegangen, in der noch nichts geschrieben wurde.

1. Im Gemfile folgendes eintragen:
```
gem 'ez_on_rails',
    '=0.7.3',
    git: 'https://github.com/D4uS1/ez-on-rails',
    glob: 'EzOnRails/ez_on_rails.gemspec',
    branch: 'main'
```

2. Bundler ausführen oder Docker-Container bauen
```
bundle install
------------------
docker-compose build
```
    
## Erste Schritte
### Afbau des Applikations-Grundgerüsts
Zunächst sollte das Grundgerüst der Applikation erstellt werden.
Die folgenden Befehle müssen im Falle bei der Benutzung von Docker im Docker Container ausgeführt werden.
dazu muss der Generator _ezapp_ ausgeführt werden.

````
bundle exec rails generate ez_on_rails:ezapp Meine-Neue-Rails-App
````

Wenn nun das Grundgerüst aufgebaut ist, können weitere Generatoren genutzt werden.
Im folgenden werden diese kurz erklärt.
Zudem werden nach den Generatoren einige weitere nützliche Funktionen sowie Tipps und Tricks im Umgang mit EZ-OnRails gezeigt.

EzOnRails ermöglicht es Benutzern sich auf verschiedene Arten und Weisen zu authentifizieren.
Somit kann EzOnRails auch für API Schnittstellen genutzt werden oder als OAuth Provider dienen.
Gegebenenfalls müssen aber für bestimmte AUthentifikationsmöglichkeiten noch Installationsinstruktionen ausgeführt werden.
In diesem Fall sollte [dieser Abschnitt](## Authentifikationsmethoden) eingesehen werden.

Nicht zu vergessen: Datenbank migrieren und seeden
```
rails db:migrate
rails db:seed
```

### Hinweis zum Testen
Mit Erstellung der App werden auch Tests mitgeliefert, die über rspec ausgeführt werden können.
Diese Tests enthalten System-Integrationstests, welche Capybara benutzen.
Damit der Capybara Server funktioniert muss dieser konfiguriert werden.
Dies geschieht in der generierten Datei __spec/support/capybara_config.rb__.
Die hier vorgenommene Standard-Konfiguration ist für eine Docker-Umgebung eingerichett, welche
Selenium in einem Container ausführt. Diese Docker-Konfiguration wird im folgenden Abschnitt erläutert.
 
### Hinweise zum Javascript
EzOnRails benutzt einige NPM Packages die es erfordern, dass die Rails Initialisierungen die normalerweise in der application.js
vorgenommen werden, in der Javascript Datei von EzOnRails stattfinden müssen.

Falls ein manuelles Layout genutzt wird, wo die Javascript Datei eingebunden wird, muss sichergestellt werden, dass:

1. das EzOnRails pack als erstes geladen wird und
2. Das die folgenden Zeilen aus der application.js entfernt werden, weil diese ohnehin schon verwendet werden:
```
require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

...

var componentRequireContext = require.context("components", true);
var ReactRailsUJS = require("react_ujs");
ReactRailsUJS.useContext(componentRequireContext);
```

### Kurze Erläuterung zur Benutzerverwaltung
Wenn die Applikation erstellt wurde und die Datenbank migriert wurde, befindet sich im System ein Benutzer 
__SuperAdministrator__ mit dem Passwort __1replace_me3_after3_install7__.
Natürlich sollte sich schnellstmöglich mit diesem Account eingeloggt werden und das Passwort geändert werden.

Der Administrator hat Zugriff auf einen Administrationsbereich, welcher über das Menü erreichbar ist.
Hier kann er selbst folgendes tun:
* Benutzer hinzufügen / entfernen / berarbeiten
* Gruppen hinzufügen / entfernen / berarbeiten
* Benutzern Gruppen zuweisen
* Zugriffe für Gruppen festlegen
* Festlegen, welche Resourcen Benutzerabhängig sichtbar sind

## Erläuterung des Berechtigungssystems
Das Berechtigungssystem basiert auf Gruppen. Jeder Benutzer kann eine beliebige Anzahl von Gruppen haben.
Jede Action kann eine beliebige Anzahl von Gruppen haben.
Jeder Controller kann eine beliebige Anzahl von Gruppen haben.
Jeder Namesapce kann eine beliebige Anzahl von Gruppen haben.
Bei einem Seitenaufruf wird zunächst geprüft, ob zu der aufgerufenen Action eine gruppenzuwesung existiert.
Falls nicht, wird der Zugriff zugelassen, da offensichtlich keine Einschränkung vorgenommenr wird. Dennoch wird weiterhin
geprüft, ob vieleicht zum Controller eine Gruppenzuweisung existiert. Falls nicht, wird der Zugriff zugelassen.
Weiterhin geschieht das gleiche mit allen Namespaces, in dem sich der Controller befindet.

Wenn zu einer Action, einem Controller oder einem Namespace eine Gruppenzuweisung gefunden wurde, wird geprüft
ob der Benutzer ebenfalls in dieser Gruppe ist. Falls ja, wird der Zugriff zugelassen.
Somit ist es möglich recht feingranular oder grob, je nach wünschen, die Zugriffe einzuschrÄnken.

Es gilt zu beachten, dass für jeden eingebettenen Namespace die Überprüfung nacheinander stattfindet.
Befindet sich also ein Controller im Namespace ns1/ns2 wird zunächst der Zugriff für ns1/ns2 und anschließend für ns1 
geprüft.

## Erläuterung zu Ownerships
Außerdem können Resourcen definiert werden, die als "Eigentum" angesehen werden. Wenn dies für eine Resource der Fall ist,
kann ein Nutzer nur diejenigen Objekte einsehen und bearbeiten, die ihm selbst oder keinem zugewiesen sind.
Dazu hat jedes mit ezscaff (später dazu mehr) erstelles Model ein "owner" Feld, welches einen Verweis auf einen Benutzer führt.
Beim Anlegen eines Objektes wird automatisch der aktuell eingeloggte Benutzer als Eigentümer festgelegt.
Natürlich steht es jedem Frei diese Logik zu überarbeiten. Deshalb basiert nahezu alles auf generierten Dateien und findet nicht
heimlich in irgendeinem lib Ordner statt ;).

## Erläuterung zu Freigaben
Resourcen die als "Eigentum" gekennzeichnet sind, also diejenigen zu denen eine __OwnershipInfo__ existiert,
können freigegeben werden, sodass nicht nur der owner, sondern auch beliebige andere Benutzer Zugriff auf die Resource erlangen.

Um dies zu ermöglichen muss der Scaffold Generator (siehe [EzScaff](###ezscaff )) mit der Option __--sharable__ aufgerufen werden.

```
rails generate ez_on_rails:ezscaff SharableResource some_value:string --sharable
```

Nun enthält die Resource alle erforderlichen Beziehungen um die Freigabe zu erteilen.
Falls die Resource bereits existiert, aber bei der Erstellung kein __sharable__ Flag übergeben wurde, kann dies auch manuell ermöglicht werden, 
indem man zwei Dateien anpasst.
1. Im Model müssen folgende Beziehungen ergänzt werden:
```
...
  has_many :read_accesses, class_name: 'EzOnRails::ResourceReadAccess', dependent: :destroy, as: :resource
  has_many :read_accessible_groups,
           through: :read_accesses,
           source: :group,
           class_name: 'EzOnRails::Group'
  has_many :write_accesses, class_name: 'EzOnRails::ResourceWriteAccess', dependent: :destroy, as: :resource
  has_many :write_accessible_groups,
           through: :write_accesses,
           source: :group,
           class_name: 'EzOnRails::Group'
  has_many :destroy_accesses, class_name: 'EzOnRails::ResourceDestroyAccess', dependent: :destroy,  as: :resource
  has_many :destroy_accessible_groups,
           through: :destroy_accesses,
           source: :group,
           class_name: 'EzOnRails::Group'
...
```
2. Im Helper müssen in der __render_info__ folgende Teile hzinzugefügt werden:
```
...
      read_accessible_groups: {
        label: t(:'ez_on_rails.ownership_info.read_accessible'),
        label_method: :name
      },
      write_accessible_groups: {
        label: t(:'ez_on_rails.ownership_info.write_accessible'),
        label_method: :name
      },
      destroy_accessible_groups: {
        label: t(:'ez_on_rails.ownership_info.destroy_accessible'),
        label_method: :name
      }
...
```

Hierüber wird auch ersichtlich wie das System funktioniert.
Die Freigabe erfolgt über die Gruppen. Jedes Model kann drei Beziehungen zu Gruppen speichern:

1. read_accessible_groups
2. write_accessible_groups
3. destroy_accessible_groups

Wenn ein Benuter in der gleichen Gruppe ist, wie eine Gruppe die in _read_accessible_groups_ liegt, dann hat der Benutzer lesenden Zugriff auf die resource.
Wenn ein Benuter in der gleichen Gruppe ist, wie eine Gruppe die in _write_accessible_groups_ liegt, dann hat der Benutzer schreibenden Zugriff auf die resource.
Wenn ein Benuter in der gleichen Gruppe ist, wie eine Gruppe die in _destroy_accessible_groups_ liegt, dann hat der Benutzer die Erlaubnis, die Resource zu entfernen.

Die Vorraussetzung hierfür ist, dass in __OwnershipInfos__ ein Datensatz für die Resource existiert, und die Resource hier als __sharable__ markiert ist.
Der Owner hat natürlich immer vollen Zugriff auf die Resource.

Da zu jedem Benutzer eine Gruppe existiert, kann man über dieses System auch nicht nur Gruppen, sondern auch einzelnen Benutzern die Freigabe erteilen.

In den __OwnershipInfos__ existiert auch die Info, was geschehen soll, wenn der Eigentümer einer Resource gelöscht wird.
Der enum __on_owner_destroy__ kann auf die folgenden Werte gesetzt werden:
* resource_nullify - Entfernt lediglich die Referenz im Resource objekt, ohne dieses zu löschen
* resource_destroy - Löscht das Resource Objekt unter Ausführung der destroy Methode => Hooks werden aufgerufen
* desource_delete - Löscht das Resource Objekt unter Ausführung der delete Methode => Hooks werden nicht aufgerufen

## Authentifikationsmethoden
### Bearer
Es ist möglich Benutzer in EzOnRails mittels Bearer Tokens zu authentifizieren.
Dies ist insbesondere dann sinnvoll, wenn eine API existiert, die nur für bestimmte Nutzer zugänglich sein soll.
Im Gegensatz zu OAuth existiert hier aber kein Workflow für einen Login Prozess.
Hat man also Beispielsweise eine App und ein Login-Formular direkt in der App, ohne das man zum Login den Benutzer weiterleiten möchte,
ist Bearer die richtige Wahl.

### Authentifikation
Um einen Bearer Tokem zu erhalten muss ein POST Request auf den Pfad __api_user_session_path__ ausgeführt werden. Voll ausgeschrieben ist dieser Pfad __/api/auth/sign_in__.
Der Request muss im JSON Format geschehen und muss die folgenden Angaben enthalten:
* email
* password

Zurückgegeben wird nun ein Objekt für die folgende Authentifikation.
Die folgenden Angaben müssen vom Client gespeichert und für den nächsten Request übermittelt werden (im header).

* uid
* access-token
* client

ACHTUNG: Mit jedem Request wird der _access-token__ ausgetauscht. In der Antwort des Requests befindet sich dann der Token für den folgenden Request.

### OAuth
#### Einrichtung über vorinstallierte OAuth Schnittstellen
EzOnRails liefert einige OAuth Schnittstellen mit, für die lediglich die Angaben zur Applikation im Initializer 
angegeben werden müssen.
Dazu muss in der Datei __config/devise_omniauth.rb__ die jeweilige OAuth Schnittstelle angegeben werden.
Es ist empfehlenswert die Angaben für die Applikationen über die Raiols credentials abzuspeichern.

Beispiel Gitlab:
```
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :gitlab,
           Rails.application.credentials.omniauth[:gitlab][:uid],
           Rails.application.credentials.omniauth[:gitlab][:secret],
           scope: 'read_user'
end
```

Die folgenden Anbieter sind vorinstalliert und erfordern abgesehen vom Eintrag keinen weiteren Schritt.
* Gitlab

#### Einrichtung eigener OAuth schnittstellen
Um einen weiteren Anbieter hinzuzufügen müssen folgende Schritte durchgeführt werden.

1. Gem installieren: Für die OAuth Implementation wird Devise Omniauth genutzt. 
Eine Liste der verfügbaren Gems findest du [hier](https://github.com/omniauth/omniauth/wiki/List-of-Strategies).

2. Die Applikation beim Anbieter erstellen. (Die Credentials sollten im Rails credentials store abgelegt werden)

3. Im Initializer ____config/devise_omniauth.rb__ den Eintrag für den Anbieter erstellen.
 
4. Einen Callback für doe Oauth Schnittstelle einrichten.
Dazu kannst du den Generator [ezuser](###ezuser) benutzen. Benötigt wird von den erstellten Dateien nur der Controller
__app/controllers/users/omniauth_callbacks_controller.rb__, alle anderen Dateien können entfernt werden.

Hier musst du den Callback einrichten. Orientier dich dabei am besten an den bereits vorhandenen Callbacks. Wenn du dir unsicher bist und denkst das deine
Schnittstelle die korrekten Scopes eingetragen hat und die Daten entsprechend liefert, kannst du auch einfach den __default_callback__ in der Klasse verwenden.

Bitte beachte, dass der Beutzer die Datenschutzerklärungen akzeptieren sollte. Aus diesem Grund gibt es im Falle der nicht Existens eines 
Benutzers im Default Callback eine Weiterleitung zu einem Formular, wo der Benutzer die Erklärung akzeptieren muss. Das solltest du 
auf jeden Fall in deinem Callback beibehalten.

5. Ggf. Den Link für die Anmeldung iom Login Formular einfügen, alölerdings sollöte das in den Standard Formularen bereits automatisch geschehen.

#### Authentifikation
Nachdem der Benutzer sich eingeloggt hat erhält er einen Token, den er bei den weiteren Requests im Header übergeben muss.
Im HTTP Header muss dieser Token dann immer übergeben werden mit jedem Request. Das Header Attribut heißt hierbei auch __authorization__.

## Weitere Generatoren
### ezscaff     
Dieser Generator erstellt eine REST-Ressource wie sie vom Scaffold Generator von Rails bereits erstellbar ist.
Der Unterschied zu einem normalen Scaffold ist, dass die Views für die Ressource über Partials zusammengebaut werden.
Nichts desto trotz existieren die üblichen nach den Konventionen benötigten Dateien.
Auf diese Weise wird ein gleiches Aussehen für jede Ressource gesichert. 
Außerdem wird die nicht ganz so leckere Copy Pasta Programmierung vermieden.
Natürlich können die Views dennoch angepasst werden.
Ein Zwang die Partials zu benutzen besteht nicht. Die Views können auch wie üblich mit Form-Buildern aufgebaut werden, sofern man Lust hat bei einer Änderung nicht eine einzige Datei, sondern gleich hunderte anzufassen ;).

```
rails generate ez_on_rails:ezscaff Hund rasse:string alter:integer 
```

Dieser Scaffold für einen  Hund besteht aus den üblichen REST-Ressource-Actions.

Auch die Angabe von Namespaces ist möglich. Dies ist insbesondere dann wichtig, wenn auch die Menüstruktur gebaut werden soll.

```
rails generate ez_on_rails:ezscaff Tiere/Hund rasse:string alter:integer 
```

Hier befindet sich die Ressource Hund im Namespace Tier.
Wenn nun ein Menüpunkt in der Navigation erstellt wird, der zur Hund-Ressource verweist, wird der Namespace als Hauptmenüeintrag genutzt.
Dazu später mehr in der Erstellung der Navigation.

Prinzipiell werden die gleichen Dateien erstellt wie bei einem rails Scaffold, es existieren unter Anderem Controller, Helper, Model und View.
Ein Blick in die Views offenbart den eigentlichen Sinn dieses Scaffolds. Zu jeder Action wird lediglich ein Partial gerendert.

Die Partials können angepasst werden, um das Aussehen oder Verhalten entsprechend zu ändern.

Es ist auch erwähnenswert, dass alle erstellten Controller von einem _ResourceController_ erben. 
Dieser _ResourceController_ wiederum erbt vom _ApplicationController_.
im Resource Controller befinden sich Standard-Actions für eine Rest Resource. Diese können natürlich durch einfach Definition der
Methoden im Controller überschrieben werden. 
Die Benutzung der Standard-Actions spart Code und macht diesen Wartbar, wenn wirklich keine weiteren Aktionen für die Resource verwendet werden.
Für die Funktionsweise ist es allerdings erforderlich, dass dem ResourceController mitgeteilt wird, welche Resource zugrunde liegt.
Dazu muss das Feld _self.model_class_ gesetzt werden.
Dies wird natürlich im Generator berücksichtigt.

Es werden automatisch Übersetzungsdateien angelegt, welche in der Gleichen Ordnerstruktur wie üblich abgelegt werden, nur eben im Config/Locales Ordner der Applikation.
Da sich bei den Übersetzungen an die von Rails definierten Konventionen gehalten wird, können die entsprechenden Methoden von Rails genutzt werden.

Ein weiteres Kern-Element ist der Helper. 
Hier befindet sich nun eine Methode die _render\_info_ enthält. Die Partials benutzen die hier enthaltenen Informationen für die Darstellung.
Hier werden zum Beispiel Labels definiert. Die render_info kann aber viel mehr. Dazu wird später noch einiges gezeigt.
Im Laufe der Readme gibt es einen Extra Abschnitt zur Render-Info, da es sich hierbei um ein zentrales Element handelt.

Standardgemäß wird in die Seeds ein Eintrag geschrieben, der den Zugriff auf die Resource auf den Super Administrator beschränkt.
Außerdem werden request specs erstellt, die genau das prüfen.

ACHTUNG: Dieser Generator löscht den Test Ornder, weil davon ausgegangen wird, das rspec genutzt wird.

### ezform
Manchmal ist es erforderlich ein Formular zu erstellen, dass nicht auf einer Datenbankressource basiert. 
Man möchte aber ungerne auf die Features von Rails wie zum Beispiel Validierung verzichten.
Für diese Fall bietet Rails so genannte _Active Models_.
EZ-OnRails bietet einen Generator um ein solches Formular zu erstellen.
Die Syntax orientiert sich dabei an den Scaffolds.

```
rails generate ez_on_rails:ezform Internetsuche suchbegriff:string
```

Dieser Befehl wird ein Formular mit einem Textfeld _suchbegriff_ erstellen. Es sind die gleichen Datentypen wie
bei einem Scaffold möglich.
Auch hier zeigt der Blick in die erstellte View, den Controller und den Helper den eigentlichen Sinn dieses Befehls.
Die View rendert lediglich ein Partial, sodass alle Forms, die auf diese Weise erstellt wurden,
gleich aussehen. Der helper enthält wie beim Scaffold die render_info. 

Das Formular hat die Action _index_ für die Anzeige und die Action _submit_ wenn der Submit Knopf gedrückt wird.
Wenn der Submit erfolgreich war, wird auf die success action geleitet.
Angepasst werdfen sollten also die submit action und die success view, sowie ggf. die locales.

Genau wie bei ezscaff wird per default eine Zugriffsbeschränkung in den seeds eingerichtet.
Außerdem wird der entsprechende Request spec generiert.

### ezdash    
Über den Dashboard Generatoren können Dashboards mit Kacheln und Verlinkungen erstellt werden.
Dashboards können kategorieisert werden. Jede Kategorie kann ein Label und eine Menge von Kacheln haben.
Wird ein label übergeben, wird dieses gleichzeitig genutzt um das Dashboard ein- und ausklappen zu können.
Die grundlegende Idee ist, dass die Applikation in Module unterteilt ist, die anhand von Namespaces gruppiert werden.
Der Dashboard Generator nimmt den Namen eines Namsspaces entgegen und wird jede Seite die in diesem Namespace existiert
über eine Kachel verlinken.

```
rails generate ez_on_rails:ezdash Tiere
```

Befinden sich im Namespace _Tiere_ Routen zu Ressourcen oder anderen actions, werden diese nun im  Dashboard als Kachel dargestellt.
Dazu wird ein DashboardController mit einer index-Action erstellt.
Auch hier wird das Dashboard wieder über ein Partial gerendert, sodass alle Dashboards gleich ausssehen.

Damit dies funktioniert, muss dem Partial die Zusammensetzung des Dashboards mitgeteilt werden.
Dies geschieht wieder im erstellten Helper. Im Gegensatz zu den Scaffolds oder Forms hat die info Methode hier aber den prefix _dash\_info_.

Die Angaben der Kacheln werden in einem Array erwartet.
Alternativ kann dies auch eine Instanzvairable im Controller sein, dies ist allerdings eher unschön.
Das Dashboard wird kategorieweise dargestellt.
Der Array enthält für jede Kategorie ein optionales :label und einen weitere Array von :tiles.
Im :tiles befinden sich Hashes mit den Angaben zu den Kacheln.

Die __dash_info__ hat also grundlegend die Struktur:
_[ 
    {
        label: 'Kategorie 1',
        tiles: [
                    {KACHEL_1},
                    {KACHEL_2},
                    ...
                ]
    },
    {
         label: 'Kategorie 2',
         tiles: [
                     {KACHEL_1},
                     {KACHEL_2},
                     ...
                 ]
     }
    ...
]_

Wird das Label ausgelassen wird keine ausklappbare Struktur erstellt. In diesem Fall werden die Kacheln direkt dargestellt.

Die Kachel-Hashes können folgende Informationen enthalten:
* __label__: Ein Titel für die Kachel.
* __background_color__: Die Hintergrundfarbe der Kachel
* __text_color__: Die Textfarbe der Kachel 
* __text__: Ein Inhaltstext der Kachel. Dieser wird linksbündig unter dem Titel angezeigt.
* __image__: Der Pfad zu einem Bild innerhalb des images Ordner der assets, welches als Kachel verwendet werden soll. Dieses wird als Hintergrund der Kachel gesetzt.
* __icon__: Der Name eines Icons. Es handelt sich um font-awesome icons (nur fas, im free tear). Das Icon wird unten Rechts in der Kachel angezeigt.
* __link__: Ein Statischer Link, zu dem geführt wird, wenn auf die Kachel geklickt wird.
* __controller__: Ein Controller, dessen Action geöffnet wird, wenn auf die Kachel geklickt wird. Erfordert die Angabe der Action.
* __action__: Die Action des angegebenen Controllers.
* __footer__: Ein Text im Footer der Kachel. Der Footer ist ein extra Bereich unter der Kachel, der verwendet werden kann un längere Beschreibungen anzuzeigen.

Die angaben sind alle Optional. Wird zum Beispiel kein Link, Controller oder Action angegeben wird der Text einfach als Informationstext ausgegeben.
Ein label ist ebenso nicht erforderlich. Nur wenn nicht zu einem statischen link, sondern zu einem Controller und einer Action verwiesen werden soll,
sind zwingend beide Angaben erforderlich.

Über die lokale Variable _borderless_ kann definiert werden, dass die Kacheln ohne Ränder
dargestellt werden. Auch diese kann als gleichnamige Instanzvariable im Controller definiert werden.

Folgendes Beispiel rendert ein Dashboard mittels des Partials:
```
= render partial:'shared/dashboard', locals: {
    dash_info:
     [ 
        {
          label: 'Kategorie 1',
          tiles: [
              {
                title: "Some Tile",
                text: "Some Link Text",
                controller: "some_controller",
                action: "some_action",
                footer: "Some Footer Information"
              },
              {
                 title: "Some Image Tile",
                 image: "tiles/some_image.png",
                 controller: "some_controller",
                 action: "some_action"
              }
            ]
          }
      ]
   } %>
```

Wie bei ezscaff wird auch hier standardmäßig eine Zugriffsbeschränkung in die Seeds eingebaut und der zugehörige request spec generiert.

### eznav    
Zuvor haben wir uns angesehen, wie wir REST-Ressource, normale Formularseiten oder Dashboard über Generatoren erstellen.
Alle diese Seiten können in Namespaces existieren, die die Web-Applikation in Module unterteilen.
EZ-OnRails bietet einen Generator, der anhand dieser Namespace Informationen ein Navigationsmenü erstellt.

```
rails generate ez_on_rails:eznav
```         

Das nun erstelte Navigationsmenü wird in Haupt- und Submenüs unterteilt.
Der Übersicht-Halber wird auf eine weitere Hierarschieebene verzichtet.
Existieren Controller-Actions ohne Namespaces, werden diese zu Hauptmenüeinträgen.
Existieren Controller-Actions in Namespaces wird ein Hauptmenüeintrag mit Namespacenamen erstellt, welcher ein Submenü öffnet, in dem sich die Controller-Actions des Namespaces befinden.
Die Menüstruzktur wird über das Partial _views/_navigation.html.erb_ gerendert.
Hier kann das aussehen angepasst werden.
Die Menü-Informationen werden im Helper _helpers/menu_structure_helper.rb_ definiert. Die hier befindliche Methode _menu\_structure_ gibt die Menü Informationen zurück.
Der hier enthaltene Hash kann ruhig auch manuell verändert werden.
Am besten lässt sich dies anhand eines Beispiels zeigen:

```
{
  main_menus: [
    {
      label: 'Dashboard',
      controller: 'welcome',
      action: 'index'
    },
    {
      label: 'Ich habe Untermenüs',
      namespace: 'submenu_1',
      sub_menus: [
        {
          label: 'Untermenü 1',
          controller: 'submenu_1',
          action: 'index'
        },
        {
          label: 'Untermenü 2',
          controller: 'submenu_2',
          action: 'index'
        }
      ]
    }
  ]
}
```

Es handelt sich also um ein Objekt, dass den __main\_menus__  enthält.

__main_menu__ ist ein Array von Menüeinträgen. Ein Hauptmenüeintrag hat stets einen Titel __label__. 
Er kann entweder ein Ziel haben, oder Untermenüs. Wenn der Menüeintrag ein Ziel hat, 
braucht er die Felder __controller__ und __action__. 

Wird auf den Menüeintrag geklickt, wird der hier hinterlegte 
Controller und dessen hier hinterlegte Action aufgerufen. Wenn der Menüeintrag untermenüs hat,
 hat er den Eintrag __sub\_menus__. Dabei handelt es sich wiederum um einen Array von Menüeinträgen, 


### EzApi
Dieser Generator baut einen Controller und JSON Builder in einem API namespace um eine API Shcnittstelle zu generieren.
Außerdem erstellt er automatisch Integrationstest. Über diesen kann auch automatisch eine API Dokumentation mittels rswag generiert werden. Dazu später mehr.
Er kann entweder normale Actions entgegennehmen oder eine resource (oder beides).

```
rails generate ez_on_rails:ezapi Example action_one action_two
```

In diesem Fall würde im Namespace _Api_ ein Controller ExampleController erstellt werden, welcher die Actions 
_action\_one_ und _action\_two_ enthält.
Zu diesen Actions werden JSON Builder Template Dateien gebaut.
Jede erstellte Route reagiert standardmäßig als POST request.

Es kann auch eine Resrouce angegeben werden. In diesem Fall wird der Name eines zuvor erstellen EzScaff erwartet.
Der Controller wird dann automatisch mit Resourcen-Spezifischen Actions _create_, _update_, _show_, _index_ 
und _destroy_ ausgestattet.

```
rails generate ez_on_rails:ezapi Humen --resource Human
```

Natürlich können auch Resourcen-Controller erstellt werden, die zusätzliche actions enthalten.

```
rails generate ez_on_rails:ezapi Humen age name --resource Human
```

Die API reagiert genauso auf das Berechtigungssystem wie die Scaffolds. Die hier verweisenen Resourcen erhalten ggf. 
Benutzereigentümer oder haben generelle Restriktionen auf namespaces, actions oder controller.

Aber Vorsicht:
Da der ApiController nicht nur die Standard-Resourcenfunktionen erhalten kann, wird er nicht standardgemäß pluralisiert.
Wenn man also einen reinen Resource-Generator haben möchte, sollte man den Plural selbst angeben.

#### Authentifizierung
Wenn die API Schnittstelle authentifizierbar sein soll, kann dies über die Option __--authenticable__ angegeben werden.
In diesem Fall werden im Header für die Requests Informationen zur Authentifikation erwartet.
Dieses wird in den integrationstests automatisch berücksichtigt.
__authenticable__ kann dabei den Wert __bearer__ oder __oauth__ haben, je nachdem für welche Methode der API Authentification man sich entscheidet.

```
rails generate ez_on_rails:ezapi Human --resource Human --authenticable bearer
```

#### Versionierung
Beim ausführen von EzApp wird auch ein Initializer kopiert (api.rb).
In diesem befindet sich die Konstante API_VERSION.
Diese wird von allen Specs die über EzApi generiert werden verwendet, um die Version des Clients zu überprüfen.
Wenn diese nicht mit der Koinstante übereinstimmt, wird ein Status 410 zurückgegeben.
Die Version sollte also immer zwischen Client- und Server konsistent gehalten werden.

#### API Dokumentation erstellen
Durch die Generierung der API mittels des soeben gezeigten Befehls wird ein integrationstest erstellt.
Über diesen kann über folgenden Befehl eine Dokumentation generiert werden:

```
rails rswag:specs:swaggerize
```

Die Dokumentation kann über '/api-docs' erreicht werden. 
Angepasst werden sollte diese über die Integrationstest, da mit jedem Ausführung des soeben genannten Befehls die Doku aus
dieser aktualisiert wird.
Weitere Infos sollten der Github Seite von [rswag](https://github.com/rswag/rswag) entnommtn werden.

#### Suche
Wenn man eine Schnittstelle für eine Resource über ezapi erstellt, bekommt man einen Endpunkt für eine Suche.
Out of the box kann hier eine Suche ausgeführt werden, um eine Menge von Records zu erhalten, die einem gewünschten
Filterkriterium entsprechen.
Die Filter werden (wenn noch nicht vorhanden) im __spec/swagger_helper.rb__ in den Schemas _SearchFilter_ und _SearchFilterComposition_
definiert. Grob gesagt kann ein Filter beliebig kombiniert werden aus diesen beiden Schemas.
Beispiel: 
```
filter: { field: 'name', operator: 'contains', value: 'ez' }
filter: { logic: 'and', filters: [{ field: 'name', operator: 'contains', value: 'ez' }, { field: 'id', operator: 'gt', value: '1' }]
```
Die Filter können beliebig verschachtelt werden. 

Die Suche geschieht über das Gem [scoped_search](https://github.com/wvanbergen/scoped_search).
Die erlaubten Suchschlüssel werden aus den Datenbankspalten zusammengesetzt.
Wenn man mit ezscaff ein Model generiert hat, findet man dort die Zeile:
```
  scoped_search on: self::search_keys
```

Die Methode __search_keys__ ist Teil des __EzOnRails::ApplicationRecord__ und gibt einfach alle Datenbankspalten des Recods zurück.
Wenn bestimmte Felder nicht erlaubt sein sollen oder gar andere hinzukommen sollen, sollte diese Zeile angepasst werden.

Es ist auch möglich mit scoped_search in Relationen zu suchen.
Sollte mehr nötig sein, als nach den Standardattributen zu filtern, sollte die Dokumentation von scoped_search konsultiert werden.

Der Standard-Such Action kann übrigens auch __page__ und __page_size__ für eine pagination mitgegeben werden. 
Außerdem kann über __order__ und __order_direction__ eine Sortierung vorgenommen werden.
Die page ist 0 indiziert, page_size gibt aber die Anzahl an Seiten 1 indiziert an (wie bei Arrays).
### EzDev
Wenn beim Entwickeln Docker + docker-compose + Rubymine + gitlab-ci verwendet wird, kann nach der Erstellung der App dieser Generator aufgerufen werden,
um Dateien zu Kopieren und zu injecten, die ein stressfreies Entwicklen ohne weitere Einrichtungsvorgänge ermöglichen.

Dazu muss nur der Generator wiefolgt aufgerufen werden:
```
rails generate ez_on_rails:ezdev AppName
```
Der Name der App muss mit übergeben werden, damit die Datenbanktabelle richtig benannt wird.

Es wird empfohlen folgende Docker-Files bzw. compose files und database.yml zu verwenden. Dabei sollte natürlich auch hier alles entsprechend des App Namens angepasst werden.
Dockerfile:
```
FROM ruby:2.7.2
RUN apt-get update -qq && apt-get install -y build-essential
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && apt-get install -y nodejs
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - &&\
 echo "deb https://dl.yarnpkg.com/debian/ stable main" >> /etc/apt/sources.list.d/yarn.list &&\
 apt-get update && apt-get install yarn
RUN apt-get install -y vim
RUN mkdir /AppName
WORKDIR /AppName
COPY . /AppName
RUN bundle install
```
docker-compose.yml:
```
version: '3.8'
services:
  db:
    image: postgres
    volumes:
      - ./tmp/db:/var/lib/postgresql/data
    environment:
      - POSTGRES_PASSWORD=postgres
    ports:
      - "5432:5432"
  web:
    build: .
    command: bash -c "rm -f tmp/pids/server.pid && bundle exec rails s -p 3000 -b '0.0.0.0'"
    volumes:
      - .:/AppName
    ports:
      - "3000:3000"
    environment:
      - SELENIUM_URL=http://chrome:4444/wd/hub
    depends_on:
      - db
  chrome:
    image: selenium/standalone-chrome:latest
    volumes:
      - /dev/shm:/dev/shm
```

database.yml:
```
default: &default
  adapter: postgresql
  encoding: unicode
  host: db
  username: postgres
  password: postgres
  pool: 5

development:
  <<: *default
  database: app_name_development

test:
  <<: *default
  database: app_name_test
```

Nun kann einfach im Container rspec und ruboyop verwendet werden.
Außerdem sind die Gems für das Debuggen mit Rubymine installiert.

Der Generator wird die database.yml in die gitignore schreiben. Das hängt damit zusammen, dass nicht jeder mit Docker arbeiten will.
Stattdessen wird eine database.example.yml erstellt, welche im Repo vorhanden sein sollte.
Ggf. müssen hier noch anpassungen vorgenommen werden.

### EzUser
Beim Ausführen von EzApp wird ein Standard Use Case für Benutzer angelegt. 
Da aber gerade die Benutzer häufig angepasst werden müssen (Views für Login, Authentifizierungsmethoden usw.),
können die Resourcen die zum customizen der Benutzer benötigt werden aus EzOnRails gezogen werden.
Dazu muss lediglich folgendes ausgeführt werden:

```
rails generate ez_on_rails:ezuser
```

Dies wird die Controller, den Helper, das Model, die Views, die locales und die routen aus EzOnRails in die Hauptapplikation ziehen,
sodass diese anpassbar sind.

### EzViews
Dieser Generator kopiert das application layout und alle zugehörigen Partials von EzOnRails in die Hauptapplikatoion,
sodass diese angepasst werden können um das Design der Applikation zu ändern, ohne den Core von EzOnRails anpassen zu müssen.

Die Views sollten mit Vorsicht angepasst werden, da diese auch von der Administrationsoberfläche genutzt werden und teilweise
anhand der Berechtigungen des aktuellen Benutzers Dinge aus- oder einblenden.
Deshalb am besten vorm anpassen genau anschauen.

```
rails generate ez_on_rails:ezviews
```

Anhand dieses Befehls werden die folgenden Ordner mit Dateien erstellt.
* views/ez_on_rails/layouts
* views/ez_on_rails/shared

Die Controller von EzOnRails werden automatisch das entsprechende Layout der Hauptapplikation ziehen, sofern dies verfügbar ist.
Ebenso verhält es sich mit den Partials.

### EzHelpers
Die Partials von EzOnRails benutzen Helper zum Darstellen der Bestandteile von __render_infos__ und __dashboard_infos__.
Diese Helper können in die Hauptapplikation verschoben werden, um diese anzupassen.

Diese Funktion ist mit Vorsicht zu genießen, da ein Update von EzOnRails diese kopierten Helper nicht berühren wird.

```
rails generate ez_on_rails:ezhelpers
```

Dieser Befehl wird die folgenden Ordner und Dateien erstellen:
* helpers/ez_on_rails/ezscaff                       - Die Renderer für die Scaffolds (Siehe [NNeue Renderer für Attributtypen definieren](###Neue Renderer für Attributtypen definieren))
* helpers/ez_on_rails/ez_paginator_renderer.rb      - Die Klasse zum Rendern des Paginators von will_paginate

## EzWelcome
Dieser Generator kopiert alle Resourcen um die Willkommensseite anzupassen, ohne den Core von EzOnRails anpassen zu müssen.

```
rails generate ez_on_rails:ezwelcome
```

Folgende Dateien/Ordner werden erstellt:
* controller/welcome_controller.rb
* views/welcome
* helpers/welcome_helper.rb
* config/locales/welcome

## EzContact
Dieser Generator kopiert alle Resourcen um das Kontaktformular anzupassen, ohne den Core von EzOnRails anpassen zu müssen.
Dabei wird sowohl die Seite für das Kontaktformular, als auch die Mailer berücksichtigt.

```
 rails generate ez_on_rails:ezcontact
 ```

Folgende Dateien/Ordner werden erstellt:
* app/controllers/contact_form_controller.rb - Der Controller für die Kontaktformularseite
* app/mailers/contact_form_mailer.rb         - Der Mailer für das Kontaktformular
* app/helpers/contact_form_helper.rb         - Der Helper inklusive Render Info
* app/models/contact_form.rb                 - Das active_model für das Formular
* app/views/contact_form                     - Die Views für die Kontaktformularseite 
* app/views/contact_form_mailer              - Die Views für die E-Mails
* config/locales/contact_form.*.yml          - Die Dateien für die Übersetzungen


## EzImprint
Dieser Generator kopiert alle Resourcen um die Impressumsseite anzupassen, ohne den Core von EzOnRails anpassen zu müssen.

```
rails generate ez_on_rails:ezimprint
```

Folgende Dateien/Ordner werden erstellt:
* controllers/imprint_controller.rb
* views/imprint
* helpers/imprint_helper.rb
* config/locales/imprint.de.yml
* config/locales/imprint.en.yml

## EzPrivacy
Dieser Generator kopiert alle Resourcen um die Datenschutzerklärung anzupassen, ohne den Core von EzOnRails anpassen zu müssen.

```
rails generate ez_on_rails:ezprivacy
```

Folgende Dateien/Ordner werden erstellt:
* controllers/privacy_policy_controller.rb
* views/privacy_policy
* helpers/privacy_policy_helper.rb
* config/locales/privacy_policy.de.yml
* config/locales/privacy_policy.en.yml

## Validatoren
EzOnRails liefert auch validatoren, die verwendet werden können.

### json_schema
Man kann JSON Felder gegen ein Schema validieren, damit man wenn man json oder jsonb Felder verwendet eine integere Datenbasis hat
und nachvollziehen kann welches Schema in diesem Feld möglich ist.
Dazu kann der Validator wiefolgt aufgerufen werden:
```
class MyRecord < ApplicationRecord
    validates :field_name, json_schema: true
end
```
In diesem Fall geht der Validator von einem Schema __app/models/json_schemas/my_record/field_name.json__ aus.
Dort kann dann Beispielsweise folgendes stehen:

```
{
  "type": "object",
  "properties": {
    "nullable_string": {
      "type": ["null", "string"]
    },
    "not_nullable_integer": {
      "type": "integer"
    }
  },
  "required": ["not_nullable_integer"]
}
```
Es wird also erwartet, dass im json_schemas Ordner unter models ein Ordner für das Model existiert und dort
das entsprechende json feld ein schema enthält.

Sollte das Schema an einer anderen Stelle gewünscht sein, kann man dieses auch als Parameter übergeben:
```
class MyRecord < ApplicationRecord
    validates :field_name, json_schema: { schema: Rails.root.join('app', 'json_schema.json') }
end
```

WICHTIG: Wenn ein json Feld in einem Controller submittet wird, muss es auch permittet werden.
Ansonsten wird der Submit das json Feld ignorieren.
Dazu kann die __resource_params__ Methode im Controller überschrieben werden.
```
class SomeRecordController < EzOnRails::ResourceController # funktioniert auch für EzOnRails::Api::ResourceController

...
protected
  def resource_params
    params.require(:some_record).permit(
      default_permit_params(render_info_some_record) + [field_name: [:nullable_string, :not_nullable_integer]]
    )
  end
end

```

## Weitere Funktionen
### Eigener OAuth Provider
EzOnRails liefert  für den API Zugriff einen Oauth Provider mit (über doorkeeper).
Für die OAuth Zugriffe müssen die entsprechenden Applikationen angelegt werden.
Dies geschieht über den Aufruf der Applikationsseite unter __oauth/applications__.

Man muss als Administrator eingeloggt sein um die Applikationen einzutragen.
Als Callback Url muss der der Pfad __omniauth/email/callback__ angegeben werden.

Anschließend müssen die nach der Erstellung angezeigten Angaben in den credentials hinterlegt werden.

```EDITOR=vim rails credentials:edit```

dort eintragen:
```
...
omniauth:
  ez_on_rails: 
    uid: [DIE ANGEZEIGTE UID AUS DEN APPLIKATOIONEN]
    secret: [DAS ANGEZEIGTE SECRET AUS DEN APPLIKATIONEN]
...
```

Nun muss in der __config/initializes/devise_omniauth.rb__ folgender Eintrag erstellt werden (Im Default ist dieser bereits vorhanden und
muss nur auskommentiert werden.)
```
...
 provider :email,
           Rails.application.credentials.omniauth[:email][:uid],
           Rails.application.credentials.omniauth[:email][:secret],
          scope: 'profile email'
...
```

Die Authentifikation erfolgt nun über den Pfad __api/auth/email__.

Der Provider heißt wegen devise_token_auth email. Das hängt damit zusammen, dasss wir nicht wollen, das nach dem Einloggen ein neuer Benutzer mit der Info des 
Providers ez_on_rails angelegt wird.

Des weiteren findet wie üblich der Tokenaustausch statt.

### Überschriften und Unter-Überschriften
Das Partial _shared/\_title.html.erb_ enthält ein Template für eine Überschrift. 
Standardmäßig wird dies vom Application-Layout des ezapp-Generators verwendet.
Das Partial übernimmt die lokale Variablen __title__ und __subtitle__. 
Existiert diese lokalen Variablen nicht, versucht das partial den Titel über die Instanzvariable __@title__ und den Untertitel über die Instanzvariable
__@subtitle__ des Controllers zu erhalten. 
Dementsprechend kann, sofern das Partial genutzt wird, die Überschrift verwendet werden, wenn der Controller diese als Instanzvaraible setzt oder die View den entsprechendne Title als Local übergibt.
Also entweder:
```
class SomeController < ApplicationController
  def some_action
    @title = "Some Action"
    @subtitle = "Some amazing subtitle"
  end
end
```
oder:
```
= render partial: 'shared/title', locals: { title: 'Some Action', subtitle: 'Some amazing subtitle' } %>
```

Es ist empfehlenswert für die Überischt des Benutzers den Titel über den Controller hinweg für jede Action konsistent zu halten.
Die Untertitel können dann durch die Actions ausgetauscht werden. Wenn dies so gewünscht ist, kann eine Abhilfe aus dem _ApplicationController_ genutzt werden.
Hier befindet sich eine Methode _set\_title_. Diese wird automatisch vor jeder action aufgerufen.
Diese Methode kann überschrieben werden um den Titel festzulegen, sodass er für jede Action erscheint.
Es ist sinnvoll dern Titel über diese Methode zu setzen, da wir Code Duplikate in den Actions vermeiden wollen. Würden wir den Titel im Konstruktor festlegen, kann es bei einem Sprachwechsel wiederum passieren, dass diesewr nicht geändert wird, da Rails nicht für jeden Seitenaufruf den Controller neu instanziiert.
Also:

```
class SomeController < ApplicationController
  def some_action
    @subtitle = "Some amazing subtitle"
  end
  
  protected
  
  def set_title
      @title = "Some Controller title"
  end
end
```

### Darstellung von einfachen Tabellen
Das Partial _shared/\_table.html.erb_ kann eine Tabelle anzeigen ohne deren Darstellung selbst übernehmen zu müssen. 
Das Partial übernimmt die zwei lokalen Variablen __table\_header__ und __table\_rows__:

* __table\_header__ ist ein Array von Strings für die Tabellenüberschrift. 
* __table\_rows__ isgt ein Array von einem Array von Strings. Die "Sub-Arrays" sind die Zeilen. Die Strings die Spaltenwerte.

Also :
```
render partial: 'shared/table', locals: {table_header: ["Spalte 1", "Spalte 2"], table_rows: [["Wert Zeile 1 Spalte 1", "Wert Zeile 1 Spalte 2"], ["Wert Zeile 2 Spalte 1", "Wert Zeile 2 Spalte 2"]]}
```
Dies ist lediglich eine sehr einfache Art von Tabelle ohne große Funktionalität. Sie dient im wesentlichen zur Darstellung statischen Inhalts.
Für eine erweiterte Tabelle mit mehr Funktionen, insbesondere im Hinblick auf die Darstellung von Datenbankresourcen, existiert eine erweiterte Tabelle, welche im folgenden Abschnitt erläutert wird.

### Darstellung von erweiterten Tabellen
Das Partial __shared/\_enhanced\_table__ ist eine Tabelle mit einigen optionalen Zusatzfunktionen.
Die Tabellen können selektierbar sein, sodass Checkboxen vor jeder Zeile dargestellt werden.
Ihr können in diesem Zuge Aktionen zugewiesen werden, die beim Klick auf definierbafre Buttons unter der Tabelle aufgerufen werden. Diesen Aktionen werden dann
die ausgewählten Tabellenzeilen übergeben.

Die Tabelle ist im wesentlichen zur Darstellung von Datenbankresourcen gedacht.

Das Partial erwartet folgende lokale Variablen:
* __:table_id__ - Ein String, der der Tabelle als ID zugeiwesen wird. Wird benötigt, wenn mehrere Tabellen auf einer Seite existieren, dieselektierbar sind.
* __:table\_header__ - eim Hash mit Informationen zum Header
    * __:cols__ - Ein Array von Hashes für die Spalten der Tabellenüberschrift
        * __:content__ - Ein String, der die Überschrift darstellt
        * __:col_class__ - Die hier angegebenen Klassen werden dem th Element der Spalte übergeben
* __:table\_rows__ - ein Array von Hashes für die Zeilen des Inhalts, dabei hat jede Zeile:
    * __:id__ - Die ID einer Zeile, wird benötigt falls die Tabelle eine Auswahlliste bereitstellt
    * __:cols__ - Ein Array von Hashes mit Spalteninformationen, die Hashes haben dabei folgenden Inhalt
        * __:content__ - Der Inhalt der Spalte
        * __:col_class__ - Die hier angegebenen Klassen werden dem td Element der Spalte übergeben
    * __:data__ - Ein Hash von data-attributen, die der Zeile angehangen werden. Wenn es sich um eine selektierbare Tabelle handelt, werden diese in den Callbacks übergeben.
* __:selectable__ - ein Hash mit Infos, der, wenn er bereitgestellt wird, die Tabelle zu einer Auswahltabelle mit Checkboxen macht
    * __:actions__ - Ein Array von Hashes für Aktionen, die anhand der Auswahl getätigt werden kann. Für jede Aktion wird ein Button gerendert.
        * __:label__ - Das Label des Buttons
        * __:type__ - Der Typ des Buttons (Bootsterap entsprechend, secondary, primaty usw.)
        * __:target__ - eine URL (nach Rails) die beim Klick auf den Buttom aufgerufen wird. Beim Aufruf wird die Liste der sleektierten Zeiulen als JSON Array als Parameter "selections" übergeben. Wird mit url_for interpretiert.
        * __:method__ - die HTTP Methode der URL
        * __:onclick__ - Eine Funktion die Aufgerufen wird (anstelle der URL). Die Funktion muss als Parameter eine Variable übernehmen, in der die selektierten Zeilen übergeben werden. Zudem muss sie an das Dokument ($) gehangen sein.
        * __:confirm__ - Ein Boolean, wenn eine normale Confirm Nachricht auftauchen soll, die bestätigt werden muss bevor die angegeben action ausgeführt wird. Ein String, wenn die Nachricht geändert werden soll. Ein Hash wenn die Nachricht, der Titel und die Buttons geändert werden sollen. In diesem Fall muss der Hash das Format haben wie es die Funktion _confirm\_data_ im _UrlHelper_ vorsieht. 
        
Damit die Selektion funktioniert, muss jede Zeile eine netsprechende ID haben.
Wenn ein Button geklick wird, wird entweder die Url mit der übergebenen Methode aufgerufen, die durch target beschrieben wird, oder
die Javascript Methode aufgerufen.
Wichtig ist, dass wenn auf einer Seite mehrere Tabellen existieren die selektierbar sind, die Tabellen eine ID besitzen müssen, damit
die selektierten Zeilen der Tabelel zugeordnet werden können.
Die Parameter der action in target oder der funktion in onclick müssen :selections erwarten. Hierbei handelt es sich um einen Array, welcher Hashes enthält. Die Schlüssel der Hashes sind :id und :data. :id speichert die Tabellen id, :data die Werte der Datenattribute.

Puh, das war viel Inhalt. Aber keine Sorge, für das alles gibt es natürlich Helper:
Im Helper __EzOnRails::EzScaffHelper__ gibt es die Helper-Methoden __get\_table\_headers__ und __get\_table\_rows__.
* _get\_table\_headers_ übernimmt die _render\_info_ einer Resource und baut die Informationen für die erforderliche _table\_header_ Variable automatisch zusammen.
Die Methode benötigt als zweiten Parameter die aktuellen lokalen Variablen der View, da der Helper auf diese nicht direkt zugreifen kann.
In diesen Variablen können zusätzlich folgende Werte übergeben werden:
    * print_show: true - Zeigt hinter jedem Eintrag einen Anzeigen Link, welcher zur show action der Resource führt.
    * print_edit: true - Zeigt hinter jedem Eintrag einen Bearbeiten Link, welcher zur edit action der Resource führt.
    * print_destroy: true - Zeigt hinter jedem Eintrag einen Löschen Link, welher zur destroy action der Resource führt.
    * print_controls: true - Zeigt alle zuvor erwähnten Links
* _get\_table\_rows_ übernimmt eine Collection von Resourcen. Dabei kann es sich direkt um selektierte Mengen von Models halten. Außerdem werden auch hier die _render\_info_ und lokalen Variablen der View benötigt.
Die Methode wird automatisch einen Array von Hashes zusammenbauen, wie er von _table\_rows_ benötigt wird.

Für die Selections existiert der Helper __EzOnRails::EzAjaxHelper__ zur interpretation von Parametern die mittels Ajax übermiottelt wurden.
Dieser wird im __EzOnRails::ResourceController__ eingefügt. Er kann aber auch ohne Resource mittels include genutzt werden.
Dazu später mehr im Abschnitt __Enhanced Table actions__.

Die Selektierung kann auch über die angabe des selectable vom index_partial heraus geschehen.

#### Enhanced Table actions
Wählt der Benutzer eine Reihe von Zeilen aus einer Enhanced Table aus und führt eine der actions aus, die als selectable übergeben wurden,
so stehen innerhalb der Action die der Benutzer ausführt einige Helper Methoden zur Verfügung um die Ausführung zu vereinfachen.

Die Methode _enhanced_table_selections_action_ übernimmt einen Block, der wiederum die Parameter __selected_ids__ und __selected_data__ übernimmt.
Dabei ist __selected_ids__ ein Array von ids die der Benutzer ausgewählt hat und __selected_data__ ein Hash, dessen Schlüssel die ids sind. Die Werte des
Hashes sind Daten die im DOM unter den data Attribute der Zeile verfügbar waren. Unter anderem auch die ID und der Typ des Objekts.
Die Methode wird nun den übergebenen Block ausführen und anschließend einen redirect zur index action ausführen.
Soll der Redirect woanders hin stattfinden, muss dieser als Parameter übergeben werden.
Beispiel:
```
...
# POST /somethings/my_custom_selection_action
def my_custom_selection_action
  enhanced_table_selections_action do |selected_ids, _selected_data|
    puts 'hello world and get back to index'
  end
end
...
```

Um die Daten für die selections direkt zu erhalten existiert die Methode _enhanced_table_selections(params)_ um die Parameter des requests zu interpretieren.
Die Methode gibt die ausgewählten Elemente als Liste zurück. Diese sollte aber nur nötig sind, wenn die zuvor genannte Methode nicht genommen werden kann.


### Breadcrumbs
Das Partial _shared/\_breadcrumbs.html.erb_ zeigt Breadcrumbs an.
Standardmäßig wird dieses Partial im Layout des ezapp-Generators verwendet.
Diese müssen mithilfe des Gems _load_ eingebaut werden. Sie können sowohl im Controller, als auch in Actions eingebaut werden:

```
class Blog::CategoriesController < ApplicationController

  breadcrumb 'Article Categories', :blog_categories_path, only: [:show]

  def show
    breadcrumb @category.title, blog_category_path(@category)
  end
end
```

Um Beispielsweise ein Root-Breadcrumb einzusetzen, welches auf die Startseite verweist, muss das Breadcrumb im ApplicationController gesetzt werden:

```
class ApplicationController < ActionController::Base
  breadcrumb 'Home', :root_path
end
```

Wenn dann das Partial genutzt wird, werden diese Breadcrumbs angezeigt.

Hinweis: Um zu gewährleisten, dass bei der Veränderung der Sprachauswahl die Breadcrumbs ebenso übersetzt werden, ist es besser deren Erstellung in Methoden 
auszulagern und mittels _before\_action_ aufzurufen. Also:

```
class Blog::CategoriesController < ApplicationController
  before_action :breadcrumb_blog_categories

  def show
    breadcrumb @category.title, blog_category_path(@category)
  end
  
  protected 
  
  def breadcrumb_blog_categories
    breadcrumb 'Article Categories', :blog_categories_path, only: [:show]
  end
end
```

## Die Render-Info
Im Abschnitt zum EzScaffold Generator wurde bereits erwähnt, dass dieser im Helper des Scaffolds eine Methode erstellt, welche die _render\_info_ für die Partials zurückgibt, damit diese
die Felder der Resource korrekt darstellen.
Im folgenden wird hier auf die Details dieser Info eingegangen.
Die Render Info ist ein Hash, dessen Schlüssel die Namen der Attribute des zugrundeliegenden Models tragen.
Zusätzlich können hier auch Informationen eingetragen werden, die nicht im Model liegen.
Den Schlüsseln werden wiederum Hashes zugewiesen, welche die Render-Infos für die Attribute enthalten.

### Labels
Die einfachste und wichtigste Funktionalität ist das zuweisen eines Labels. Dieses label bestimmt, welchen Titel die Attribute der Resource in der Übersichtstabelle der index Action, auf der Anzeige der show action oder beim Anlegen und Bearbeiten über die edit und new Action haben.

Ein Label kann eine __label_class__ haben. Dies ist ein String der dem Label als css Klasse angehangen wird.

```
def render_info_example
  {
    string_label: {
      label: 'Das ist ein String',
      label_class: 'other-label-style'
    }
  }
end
```

Generell kann ein Label entweder ein String oder ein Block, übergeben durch ein Proc sein.
Wenn das übergebene Proc einen leeren string zurücktgib, wird auch dieser leere String als label genutzt. Gibt das proc nil zurück, wird das Label nicht gerendert.
Der Sinn dahinter ist, dass man dadurch die Möglichkeit hat ggf. Einrückungen zu verhindern oder zu nutzen, je nach gewünschtem Design.

```
def render_info_example
  {
    string_label: {
      label: 'Das ist ein String'
    },
    translated_label: {
      label: Example.human_attribute_name(:translated_label)
    },
    proc_label: {
      label: proc { 'Das ist ein Proc' }
    }
  }
end

```
Übrigens: Eine durch den EzScaff Generator erstellte Resource wird auch automatisch Übersetzungsdateien anlegen.
Diese Dateien sind nach dem Standard I18n von Rails festgelegt. Dadurch können solche Funktionen verwendet werden, wie im Beispiel oben zu sehen.

## Search labels
Analog zu den Labels kann auf den gleichen weg über das Attribut __search_label__ ein Label für das Suchformular angegeben werden.
EzOnRails unterscheidet die beiden Labels, weil über die Render Info die Suche auch konfirgueirbar ist.
Es kann also gut sein, dass je nach Suchoperator ein anderes Label sinnvoll ist.

In diesem Attribut kann wie bei __label__ auch ein String oder ein Proc übergeben werden.
Wenn das __search_label__ nicht existiert, wird für das Suchformular das normale label gerendert.

```
def render_info_example
  {
    string_label: {
      search_label: 'Das ist ein String'
    },
    translated_label: {
      search_label: Example.human_attribute_name(:translated_label)
    },
    proc_label: {
      search_label: proc { 'Das ist ein Proc' }
    }
  }
end

```

### Attribut-Typen
Prinzipiell wird automatisch der korrekte Typ eines Attributs gesucht.
Wenn allerdings ein Attribut auf eine andere Art und Weise dargestellt werden soll, oder das Attribut kein Attribut im Model selbst ist, sodass nicht anhand dessen der Typ identifiziert werden kann, kann der Typ auch direkt angegeben werden.
Wird ein Typ angegeben, wird gar nicht erst versucht den Typidentifikation nicht ausgeführt.

```
  def render_info_something
    {
      type: {
        label: 'Typ',
        type: :string
      }
    }
  end
```

Es gibt einige spezielle Typen von Feldern, welche ggf. zusätzliche Angaben erfordern.
Diese Angaben liegen meist im data Attribut.
```
  def render_info_something
    {
      type: {
        label: 'Typ',
        type: :combobox,
        data: [["Type T", "t"], ["Typ S", "s"]]
      }
    }
  end
```
In diesem Beispiel wird eine Combobox (select2) dargestellt.
data enthält hier die Auswahlmöglichkeiten.

Folgende weitere spezielle Typen sind möglich:
* :password   - Zur darstellung der Eingabe mit  Punkten, erfodert kein :data
* :select  - Zur Auswahl von Elementen mittels select-Feldern (Dropdowns)  :data ist hier die Auswahl (Rails kompatibel)
* :combobox  - Zur Auswahl von Elementen mittels select2-Feldern (Comboboxen)  :data ist hier die Auswahl (Rails kompatibel)
* :nested_form - Zum einbetten einer Form, :data ist die render_info der eingebetteten Daten. Zur Nested Form gibt es aber einen weiteren Abschnitt, wo alles genauer erläutert wird.

### Assoziationen
Natürlich können auch Assoziationen dargestellt werden. 
Damit Assoziationen richtig angezeigt werden, können in den Helpern in den render_infos folgende Informationen gegeben werden.
```
...
def render_info_beispiel
...
assoc_attribute: {
    label: 'Test',
    label_method: :name,
    separator: ','
    hide_link_to: true,
    render_as: :check_boxes
}
...

end
```
Dabei gibt __label\_method__ den Schlüssel des Feldes des Zielobjektes an, der angezeigt wird um das Objekt darzustellen.
In diesem Fall wird der Wert des Feldes :name auf dem Zielobjekt ausgewählt.

__separator__ kann genutzt werden um im Falle einer has many relation festzulegen, womit anzuzeigende Elemente
getrennt werden sollen (In index und show)

__hide\_link\_to__ kann angegeben werden, um zu verhindern, dass beim rendern ein Link zum Zielobjekt erstellt wird.

__render\_as\__ gibt die Art der Anzeige beim Anlegen oder Editieren an. 
Es kann die Werte :check_boxes, :radio_buttons, :select oder :combobox haben. 
Wenn kein Wert angegeben wird, wird als Standard eine :combobox angezeigt.

Es ist möglich die URL zu denen die Objekte in den index Tabellen oder in der show action verlinkt werden zu übeschreiben.
Dazu muss das Attribute __url_for__ in der render_info gesetzt werden.
Dieses kann entweder ein String oder ein proc sein. 
Wenn es ein Proc ist, übernimmt dieses das Objekt.

```
...
assoc_attribute: {
    label: 'Test',
    url_for: proc { |obj| "#{url_for(obj)}/some_extra_stuff" },
},
fix_assoc_target_attr: {
    label: 'Test',
    url_for: 'https://irgendeineadresse.de',
},
...
```
Dies ist natürlich optional. Normalerweise wird nach Rails Standard die url mittels url_for aufgelöst.

### Enums
Enums können so dargestellt werden, dass der Benutzer nicht den Integer, sondern den zugeordenetn Schlüssel bzw.
seine Übersetzung sieht.
Dazu muss in der render_info explizit der Typ :enun übergeben werden.
Über das :data Attribut, kann der Name des Enums übergeben werden. Dies ist nicht erforderlich, wenn der Name sich nicht von dem 
Namen des Datenbankfeldes unterscheidet.

```
...
def render_info_beispiel
    ...
    ein_enum: {
        label: 'Ein Enum',
        type: :enum,
        data: :ein_enum_anderen_namens_als_das_attribut  
    }
    ...

end
```

Damit das Enum auch korrekt übersetzt wird, kann dies in der Übersetzungsdatei des Models angegeben werden.
Dabei wird folgende beispielhafte Struktur erwartet:

```
de:
  activerecord:
    enums:
      model_name:
        enum_name:
          value_key: "Translated Text"
```

### Attribute verstecken
Attribute können in bestimmten Partials oder Actions versteckt werden.
```
...
def render_info_beispiel
    ...
    hide_attribute: {
        label: 'Test',
        hide: [:index, :show, :model_form, :new, :edit, :irgendeine_action],
    }
    }
    ...

end
```
hide übernimmt einen Array von actions.

### Benutzerdefinierte Anzeige von Feldern
Es ist möglich über die render_info benutzerdefinierte Blocks zum Rendern des Felds anzugeben.
Dazu muss ein Feld in render_info den Schlüssel __:render_blocks__ enthalten.
Hier wird ein Hash erwartet mit den Schlüsseln __:index__, __:show__ und __:model\_form__.
Dort können Blocks übergebene werden (mittels Proc Klassen), welche für die Anzeige des Feldes im jeweiligen
Partial aufgerufen werden.

Als Parameter erhalten _:show_ und _:index_ die Objekte, auf die sich die Anzeige gerade bezieht, währned _:model\_form_
das _form_ objekt erhält. _:search\_form_ enthält ein hash mit den Werten :form und :obj_class.

Es kann auch __:default__ übergeben werden. In diesem Fall wird der normale Renderer aufgerufen. Dies ist dann sinnvoll, wenn man nur Custom Renderer für bestimmte Partials haben will.

Es ist auch möglich mittels eines Symbols auf einen anderen Block zu verweisen. Beispielsweise durch __:index__.

Es müssen nicht zwingend alle drei Blöcke übergeben werden. Wird einer nicht übergeben, wird dieser in dem Partial einfach nicht gerendert.

Beispiel:

 ```
 module SomeHelper
   def render_info_some
     {
         name: {
            label: 'name'
         },
         description: {
            label: 'description'
          },
         custom_render_attribute: {
             label: 'Custom Render',
             render_blocks: {
                 index: proc { |obj|
                   link_to 'Some Link', ...
                 },
                 show: :index,
                 model_form: :default
             }
 
         }
     }
   end
 end

 ```

### HTML-Optionen übergeben
Jedem Feld können mittels des Hash-Symbols __:html_options__ in der Regel die HTML optionen übergeben werden, wie man diese von Rails bereits kennt.
Zum Beispiel können darüber CSS-Klassen zum Rendern der Attribute genutz werden.

### Nested Forms
Ohja, natürlich können auch Nested-Forms dargestellt werden!
Dazu müssen in der render_info des eingebetteten Formulars diejenigen Felder die im Elternformular angezeigt werden sollen das Symbol
_nested:_ true besitzen.
In den render_infos des Elternformulars muss als Typ _:nested\_form:_ übergeben werden.

Außerdem muss über _:data_ die render_info des eingebettene Formulars angegeben werden.

Nehmen wir im folgenden Beispiel an, ModelOuter hat ein Feld inner_models, welches eine has_many Beziehung zu InnerModel darstellt.

Die beiden Render Infos können dann wiefolgt aussehen:

```
...
def render_info_inner_model
  {
    name: {
      label: 'Name',
      nested: true
    },
    some_thing: {
      label: 'Name',
      nested: true
    },
    description: {
      label: 'Beschreibung',
    }
  }
end
...
def render_info_outer_model
  {
    ...
    inner_models: {
      label: 'Innere Models',
      type: :nested_form,
      data: {
         render_info: render_info_inner_model
      }
    }
  }
end
```
Nichts desto trotz müssen noch einige Sachen beachtet werden. Es ist wichtig, dass im ActiveRecord des Eltermteiols
die nested attributes der Kinder zugelassen werden.
Also:
```
class OuterModel < ApplicationRecord
  ...
  accepts_nested_attributes_for :inner_models, allow_destroy: true
  ...
end

```

Damit die Methode für die Render Info auch beim Erstellen gefunden wird, muss in der Controllerklasse des äußeren Models diese hinzugefügt werden.
```
class OuterModelController < ApplicationController
    include InnerModelHelper
    ...
end
```

Es ist auch möglich für das Rendern der nested Form ein eigenes Partial zu übergeben. Dieses Partial erhält dann
das __form__ Element. 
Dazu muss der render_info lediglich das Attribut __:partial__ mitgeteilt werden.
Also: 
```
def render_info_outer_model
  {
    ...
    inner_models: {
      label: 'Innere Models',
      type: :nested_form,
      data: {
        render_info: render_info_inner_model,
        partial: 'custom_partial'
      }
    }
  }
end
```
Das Partial kann entweder die Render Infos benutzen oder die Felder selbst rendern.
Ein Beispiel für die korrekte Nutzung der Render Infos wäre:
```
<div class="nested-fields">
  <%# filter not renderable attributes for nested_model_form %>
  <% filter_attributes! :model_form, obj_class, render_info %>
  <% filter_attributes! :nested_model_form, render_info, obj_class %>

  <% render_info.each do |attribute_key, attribute_render_info| %>
    <%# print label %>
    <div class="form-group">
      <strong>
        <%= form.label attribute_render_info[:label] %>
      </strong>
      <%= render_attribute attribute_key, attribute_render_info, :model_form, form %>

    </div>
  <% end %>

  <%= link_to_remove_association 'Löschen', form %>
</div>
```
Die Links zum Hinzufügen einer oder entfernen einer Assoziation können ausgeblendet werden, über __hide_add__ und __hide_remove__.
```
def render_info_outer_model
  {
    ...
    inner_models: {
      label: 'Innere Models',
      type: :nested_form,
      data: {
        render_info: render_info_inner_model,
        hide_add: true,
        hide_remove: true
      }
    }
  }
end
```

#### Sonderfall: Selbstreferenzen
Wenn eine Nested Form des eigenen Typs eines Models erstellt werden soll, beispielsweise zu einem parent oder
mehreren Kindern des eigenen Typs, dann muss verhindert werden, dass die render_infos sich rekursiv aufrufen.
Für diesen Fall kann __:data__ der Name der Funktion der Render info übergeben werden, um dies zu verhinden.
Also:
```
def render_info_model
  {
    ...
    child_models: {
      label: 'Innere Models',
      type: :nested_form,
      data: 'render_info_model'
    }
  }
end
```


### Active Storage Anhänge
WICHTIG: Die Rails routen zum active storage sind per default offen. Auch die zum Upload oder ändern des Service. Um dieser
nicht nachvollziehbaren Entscheidung entgegenzuwirken wird beim erstellen durch ezapp ein Initializer erstellt, der die routes deaktiviert.
Zudem werden die nötigen routes zum Herunterladen der Blobs, also die unkritischen, wieder hinzugefügt.
Zur Absicherung des uploads bietet EzOnRails controller, die einen Upload nur nach authentifikation zulassen.
Diese können genauso benutzt werden wie die normalen active storage controller. Der ezapp Generator wird den entsprechenden
Seed erstellen um den Zugriff zu sichern. Die Benutzung der active storage Dropzone erleichtert dies, da diese per default davon ausgeht.
Die Routes werden im Generator hinzugefügt. Die "gefährlichen" und unnötigen Routen sind dabei nur auskommentiert.
Wenn also weitere Routen benötigt werden, können diese hier wieder hinzugefügt werden.
Die originalen Routen könenn im [Rails Repo](https://github.com/rails/rails/blob/a205f5110d69903857c09fbca079c112f14ebdc6/activestorage/config/routes.rb) eingesehen werden.

Für die Konfiguration des ActiveStorage bitte die Rails Dokumentation konsultieren.
Wenn man Im Model wie in der Dokumentation beschrieben Anhänge hinzufügt, können diese wie üblich über die render_info 
definiert werden. 
```
class ModelA < ActiveRecord::Base
    has_one_attachment :attachment
    has_many_attachments :attachments
end
```
Anhand der Typen wird von EzOnRails automatisch bestimmt, ob es sich um einen oder mehrere Anhänge handelt.
Standardgemäß wird im model_form partial dann ein Upload Formular gerendert.
In Show werden Bilder direkt dargestellt und andere Anhänge werden verlinkt.
Die render_infos können diverse Informationen tragen.
```
def rebder_info_model_a 
{
    attachment: {
        label: 'Anhang',
        data: { 
            max_size: 1000000,
            accept: 'image/*'
        } 
    },
    attachments: {
        label: 'Anhänge',
        separator: ',',
        data: { 
            max_size: 1000000,
            max_files: 5,
            accept: 'image/*'
        } 
    }
}
end
```
Der __:separator__ gibt im Falle von mehreren Anhängen an, wie diese separiert dargestellt werden sollen.
__:data:__ gibt diverse Optionen an, darunter den zu akzeptierenden Dateityp oder die Maximale Größe der Dateien (in Bytes), oder im Falle 
mehrerer attachments die maximale Anzahl der Dateien. Alle Angaben sind optional.
https://github.com/okonet/attr-accept kann für weitere Infos für Format etc konsultiert werden.

Es gibt einen Sonderfall für Bilder. Wenn es gewünscht ist, dass Bilder nicht winfach wie die anderen Attachments verlinkt werden,
sondern über ein thumbnail verfügen, welches angeklickt werden kann um dann eine größere Ansicht des Bildes anzuzeigen,
kann der Typ __:image__, bzw. __:images__ übergeben werden.

```
def rebder_info_model_a 
{
    attachment: {
        label: 'Anhang',
        type: :image
    },
    attachments: {
        label: 'Anhänge',
        separator: ',',
        type: :images
    }
}
end
```

Zusätzlich können die Anzahl der Dateien und deren größe Limitiert werden. Standardmäßig ist die maximale Anzahl an Dateien 10 und die größe 5MB.
Die Größe wird als __:max_size__ im __:data__ attribut erwartet (in bytes) und die maximale Anzahl an Dateien als __:max_files__.

```
def rebder_info_model_a 
{
    attachments: {
        label: 'Anhänge',
        separator: ',',
        type: :images,
        data: {
            max_files: 5,
            max_size: 3_000_000
        }
    }
}
end
```

### Datumsformat ändern
Bei __:time__, __:datetime__ oder __:date__ Feldern kann das Ausgabeformat des Datums für show und Index angegeben werden,
indem in der render_info das attribut :format angegebven wird.
Dies muss ein gültiges Format für die ruby Funktion strftime sein.

```
def render_info_some_resource
    {
      some_date: {
        label: 'Date'
        format: '%F %H:%M'
      }
    }
end
```

### Checkbox Listen
Wenn eine has_many Beziehung aus einer Menge von auswählebaren Elementen besteht, kann dies über den Typ __:collection_select__ einfach umgesetzt werden.
In diesem Fall erwartet die render_info das Feld __data__ mit den werten __items__ und __label_method__.
__items__ ist dann die Menge aus der ausgewählt werden kann, jedes Element aus items wird als Checkbox in einer Liste dargestellt.
__label_method__ wird für jeden Eintrag auf das item angewandt um das Label, also den angezeigten Namen zu erhalten.

```
def render_info_some_resource
    {
      some_references: {
        label: 'Some Set of things'
        type: :collection_select,
        data: {
            items: Things.all,
            label_method: :name
        }
      }
    }
end
```

### Zeiträume
Es ist möglich ActiveSupport::Duration Objekte darzustellen und zu erfragen, indem man in der render_info den typ :duration übergibt.
In diesem Fall erwartet :data einige zusätzliche Informationen um die Korrekten Zeitintervalle zur Verfügung zu stellen. Folgende Daten werden von data verlangt bzw sind optional:
* :max_years - Die Anzahl der maximal anzuzeigenden Jahre in der Auswahl, wenn nicht übergeben, wird 10 als Standard ausgewählt

Beispiel:
```
...
  def render_info_abo
    {
    ...
      duration: {
        label: Abo.human_attribute_name(:duration),
        type: :duration,
        data: {
          max_years: 1337,
        }
      },
    ...
    }
  end
...
```

### Sortierung deaktivieren
In den Index-Actions wird per default für jede Spalte ein "Sortierungs-Link" im Header der Tabelle erstellt.
Wenn der Nutzer auf diesen klickt wird die Ausgabe nach der Auswahl sortiert.
Dies kann verhindert werden, indem der Render-info das Attribut __no\_sort__ mitgegeben wird.

```
def render_info_some_resource
    {
      some_thing: {
        label: 'Etwas'
        no_sort: true
      }
    }
end
```

### Hilfetexte übergeben
In den Formularen können Hilfstexte übergeben werden, welche dann über die Paertials in den Form-elementen gerendert werden.
Wie immer gilt, es kann entweder ein String oder ein Proc übergeben werden. Der Block erhält dann das Formular um ggf. Anhand der Resource Hilfstexte zu generieren.

```
def render_info_some_resource
    {
      some_thing: {
        label: 'Etwas',
        help: 'Hier einfach irgendetwas eintragen.'
      }
    }
end
```

### Default-Values übergeben
Falls die Default Value eines Formular Feldes überwschrieben werden soll, kann dies wie üblich mit einem Proc oder einem Wert direkt geschehen.
Falls ein proc übergeben wird, übernimmt dieser die form als Parameter.
```
def render_info_some_resource
    {
      some_thing: {
        label: 'Etwas',
        default_value: 'Das ist der default'
      }
    }
end
```

## Suchformulare
Das Partial __search\_form__ ermöglicht es anhand render_infos ein Suchformular zu erstellen.
Standardmäßig wird die Suche mit dem generieren eines Scaffolds integriert.
Die Suche baut aktuell auf Ransack auf.
Um das Formular zu benutzen muss zunächst folgendes beachtet werden:
1. Es wird eine Post action für die Suche benötigt, diese kann zum Beispiel folgdneermaßen in der routes.rb eingetragen werden:
```
resources :some_resource do
  collection do
    match 'search' => 'some_resource#search', via: [:get, :post], as: :search
  end
end
```
2. Im Controller muss diese Action natürlich ergänzt werden, sie kann folgenden Inhalt haben:
```
...
# POST | GET search
def search
    index
    render :index
end
...
```
3. Außerdem muss die Index action angepasst werden, sodass diese die Suche auch benutzt.
```
...
# GET index
def index    
    @queue_obj = SomeResource.ransack(params[:q])
    @obj_class = SomeResource
    @resource_objs = @queue_obj.result
end
...
```
Die hier erstellten Instanzvariablen __@queue\_obj__ und __@obj\_class__ werden vom Search partial benötigt.
4. In der View kann das Search Partial nun aufgerufen werden, indem dem index Partial das Symbol __:print\_search\_form__ übergeben wird:
```
= render partial: 'shared/index', locals: {\
    render_info:  render_info_some_resource,
    resources: @resource_objs,
    queue_obj: @queue_obj,
    obj_class: @obj_class,
    print_controls: true,
    print_new: true,
    print_search_form:true\
  }
```
Alternativ kann das Partial auch direkt aufgerufen werden:
```
= render partial: 'shared/search_form', locals: {\
         queue_obj: @queue_obj,
         obj_class: @obj_class,
         render_info: render_info_some_resource,
         print_details_tag: :true\
```

Beim Aufruf des Partials gibt es die Möglichkeit die Suche in einem Details-Summary Tag anzuzeigen, sodass
sie ausgeblendet werden kann.
Dies wird mit der Option __:print\_details\_tag__ erreicht.
Sie kann entweder _true_ oder _:open_ sein. Letzteres wird den Details Tag direkt beim rendern öffnen.

In den Render Infos kann die Suche über das target __:search\_form__ wie üblich angesprochen werden.
Beispielsweise können Felder ausgeblendet werden:

```
def render_info_some_resource
    {
      name: {
        label: 'name'
        hide: [:search_form]
      },
      size: {
        label: 'size'
      }
    }
end
```

Die Render Funktionen zum Rendern der Felder befinden sich im Helper __search\_form_helper__.
Die hier existierenden Funktionen übernehmen als data anstelle des Form Objekts oder Active record Objekts
einen Hash, welcher die Werte __:obj\_class__ und __:form__ erwartet.
__:obj\_class__ ist die Klasse des Active Record Objekts.
__:form__ ist der Search Form Builder.

Standardmäßig wird ransack mit der __cont__ suche aufgerufen, welches im Prinzip auf _contains_ checkt.
Mittels __search_method__ kann dies geändert werden.

```
def render_info_some_resource
    {
      name: {
        label: 'name',
        search_method: :eq
      }
    }
end
```

## CORS 
Wenn der Server von einer Webapp angesprochen wird, die auf einer anderen URL liegt, dann kann es zu Problemen wegen CORS kommen.
Dazu bietet EzOnRails einen auskommentierten Initializer, der einfach einkommentiert werden muss.
Dieser befindet sich in der Datei __initializer/cors.rb__. 
Zuvor muss das Gem 'rack-cors' installiert werden. Also im Gemfile eintragen:

```
gem 'rack-cors'
```

## Layout und Links
Hier ein paar Worte zum Layouting und Links.
Die Partials bieten die Möglichkeit zur shcnellen navigation.
Beispielsweise können im show Partial Links zur Index Übersicht angezeigt werden usw.
In diesem Abschnitt wird eine grobe Übersicht gezeigt, wie man diese anpassen kann.

### Rechte und Linke sidebar benutzen
Das Standard-Layout hat 3 Inhaltsbereiche. Eine linke Sidebar, den Hauptbereich und eine rechte Sidebar.
Der Hauptbereich wird wie üblich direkt über die views gerendert.
Wenn etwas in den anderen Bereichen angezeigt werden soll, kann dies mittels __content\_for__ geschehen.

```
- content_for :sidebar_left
  = render partial: 'shared/something_left'
  
= render partial: 'shared/something_main'

- content_for :siedbar_right
  = render partial: 'shared/something_right'
```
Wenn die linke oder die Rechte sidebar nicht übergeben werden, werden diese auch nicht dargestellt, sodass mehr Platz für den
Hauptinhalt bleibt. Sollte dieses Verhalten nicht gewünscht sein, muss das Layout angepasst werden.

### Zusätzliche Inhalte an Form hängen
__model\_form__ und __form__ ermöglichen es mit der angabe des Parameters _:behind_submit_ zusätzliche Dinge hinter das Formular zu rendern.
Diese skann entweder ein Proc oder ein darstellbarer Wert sein. 
Wenn es ein proc ist, wird die FDorm als Parameter übergeben.
Auf diese Wiese können zum Beispiel zusätzliche Submits übergeben werden.


### Benutzerdefinierte Links
Den Partials des Scaffolds können benutzerdefinierte Lionks übergeben werden.
Beispielsweise kann dem Partial __\_show__ der Link __:index\_url\__ übergeben werden.
Somit wird der Button "zur Übersicht" mit der entsprechenden URL versehen.
Werden die Links nicht übergeben, wird versucht diese anhand der Resource oder der Resource-Klasse zu identifizieren.
Folgende Links können in den Partials angegeben werden, je nachdem ob es in den partials Buttons oder Links für die entsprechenden
Verweise gibt:
1. :index_url
2. :edit_url
3. :show_url
4. :destroy_url
5. :post_url
Die :post_url ist hier eine besonderheit. Sie wird in __\_model\_form__ genutzt um den Post-Link nach dem Submit zu identifzieren.
Hier kann zusätzlich zur :post_url eine :post_method übergeben werden, falls der post einen anderen http typ haben soll, beispielsweise :put.
:edit_url, :show_url und :destroy_url können sowohl normale URLs als auch Procs sein.
Wenn es Procs sind, wird diesen das Objekt übergeben, auf welche sie verweisen. Das Ergebnis des Procs wird dann genutzt um die URL zu identifizieren.

### Zurück Link rendern
Einige Partialsunterstützten das Rendern von Zurück Buttons.
Dazu muss dem partial der Wert __:print_back__ übergebene werden.
Dieser kann true sein oder ein Hash. Wenn es ein Hash wird das :label erwartet.
```
= render partial: 'shared/model_form', 
         locals: {
            render_info: render_info_test, 
            print_overview: true, 
            obj: @test,
            print_back: true
         }
```

### Label der Links Ändern
In den Partials ist es Möglich die Links von Controls zu ändern.
Zuvor haben wir gesehen, dass wir Beispielsweise in einer index Action angeben könmnen, ob die Elemente Verlinkungen 
zum Anzeigen, Bearbeiten oder Löschen haben sollen.
Wenn wir diese Verlinkungen nicht nur mit einem Boolean, sondern mit Informationen versehen, dann übernimmt die Tabelle 
die labels und zeigt diese an.
```
= render partial: 'shared/index', 
         locals: {
           render_info:  render_info_house,
           resources: @houses,
           print_show: { label: 'Special Show' },
           print_edit: { label: 'Special Edit' },
           print_destroy: { label: 'Special Destroy' },
           print_new: { label: 'Special New' }
         } 
```
Dies ist in allen Partials möglich, in denen die Verlinkungen angegeben werden.
Im model_form Partial kann zusätzlich der Speichern Link umbenannt werden:
```
= render partial: 'shared/model_form', 
         locals: {
           render_info: render_info_house,
           print_index: true,
           save_label: 'Special Speichern',
           obj: @house
         }
```

Im Falle der model_form wird auch ein icon vor das Label auf den Button zum Speichern gerendert.
Um dies zu verhindern muss die option __hide_save_icon__ übergeben werden.
```
= render partial: 'shared/model_form', 
         locals: {
            ...
            hide_save_icon: true,
            ...
         }
```

### Links nach der Manipulation von Resourcen
Der __ResourceController__ besitzt die protected Methoden __after_create_path__, __after_update_path__ 
und __after_destroy_path__.
Diese Methoden können überschrieben werden um das Weiterleitungsverhalten nach dem Erstellen, Aktualisieren und Löschen
einer Resource zu manipulieren.
Hier können alle Arten von Pfaden zurückgegeben werden, die von rails _redirect_to_ verstanden werden.

```
class SomeModel < EzOnRails::ResourceController 
...

  protected

  def after_create_path
     'https://some.address'
  end

  def after_update_path
     'https://some.address'
  end

  def after_destroy_path
     'https://some.address'
  end
end
```


## Modals (Dialoge)
EzOnRails liefert die Möglichkeit Dialoge im Bootstrap Design (Modals) mit Helpern anzuzeigen.
Die Modals sind in den Partials __shared/modals/\_modal__, __shared/modals/\_ok__ und __shared/modasl/\_yes_no__.
Außerdem gibt es das Modal _shared/modals/\_model\_form_, welches ermöglicht ein Formular für eine Resource in einem Dialog anzuzeigen.

Sie sollten aber eher über die Helper aufgerufen werden.
```
= modal_yes_no 'Frage', 'Ist das nicht schön einfach?', 'http://yes.com', label_yes: 'Ohja', label_no: 'Naja'
= modal_ok 'Hinweis', 'Cooler Hinweis!', 'http://ok.com', label_ok: 'Okay'
= modal_model_form('Test erstellen',
                      {
                        render_info: render_info_test,
                        obj: Test.new
                      },
                      {
                        id: 'test_form'
                      }
                      )
= modal 'Benutzerdefiniert', 'HaaTeeEmmEll', [{buttons}]

```
Das erste Beispiel zeigt einen Ja-Nein Dialog.
Dabei ist der erste Parameter der Titel des Dialogs und  der zweite der Inhalt (kann auch HTML sein).
Der dritte Parameter definiert ein Ziel, welches angesteuert wird, wenn der Ja Knopf gedrückt wird.
Dieses Ziel kann jede Art von Link sein, die rails link_to Helper auch versteht.
Danach folgt die ID. Über die ID kann der Dialog oder dessen Buttons im JavaScript angesprochen werden.
Die Buttons haben die id #{id}_button_yes und #{id}_button_no. Anschließend folgen die Titel der Buttons für
Ja und Nein.
Bis auf den Titel und den Inhalt sind alle Parameter optional.

Das zweite Beispiel ist ein OK Hinweis nach dem gleichen Schema wie zuvor.

Das dritte Beispiel ist ein model_form zum erstellen oder Bearbeiten eines ActiveRecords in einem Dialog.

Das vierte Beispiel ist ein benutzerdefinierter modaler Dialog.
Der erste Parameter ist hier der Titel, der zweite der Inhalt und der dritte ein Array von Buttons.
Die Buttons sind Hashes mit Button Informationen.
Diese müssen / können beinhalten:
* :id die ID des Buttons.
* :label der angezeigte Titel.
* :type der Bootstrap Typ, normalerweise primary oder secondary.
+ :method :get, :post, ... wenn ein target übergenen wurde
* :target link_to kompatibles Ziel.

WICHTIG: Die Helper binden die Buttons nur in der View ein. Um sie aufzurufen kann entweder JavaScript oder 
Bootstrap HTML benutzt werden.
Beispiel:
```
<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#frage">
  Anzeigen
</button>
```
Natürlich gibt es dafür auch einen Helper.
```
= target_modal_button('Modal aufrufen', 'modal_id')
```
Beim Klick auf den Button wird der Dialog nun angezeigt.
data-target definiert hier die ID des Dialogs.
Die default IDs, falls sie nicht angegeben werden sind ok oder yes_no.

## I18n
EzOnRails bietet einen __EzOnRails::EzI18nHelper__.
Dieser kann included werden um localization Methoden zu erhalten, die rails nativ nicht liefert.
Aktuelle Methoden sind: 
* human_enum_name(model_name, enum_name, value_key): Gibt den übersetzten Namen des Wertes eines Enums zurück. Dazu muss das enum wiefolgt in einem locale belegt sein:
```
de:
  activerecord:
    enums:
      some_model:
        gender:
          female: "weiblich"
          male: "männlich"
          diverse: "divers"
```
Nun kann das enum mittels __human_enum_name__ abgefragt werden.
class SomeClass 
  include EzOnRails::EzI18nHelper

...
  def some_method
    ...
    human_enum_name(SomeModel, 'gender', some_model.gener)
    ...
  end
end

## Tipps und Tricks
Schauen wir uns nun ein paar erweiterte Nutzunsgmöglichkeiten und Tipps und Tricks an. 
Dieser Abschnitt kann auch konsultiert werden, wenn manche Sachen vieleicht nicht funktionieren. Zum Beispiel wird hier die Möglichkeit erläutert, Verlinkungen manuell
anzupassen.

### Teile des Layouts ausblenden
Der ezapp Generator erstellt eine Datei __helpers/ez_on_rails/layout_toggle_helper.rb__.
Über das hier befindliche Modul können Teile des Layouts ausgeblendet werden, indem die Rückgabewerte der entsprechenden
Methoden geändert werden.

### Designanpassungen
Der ezapp Generator erstellt eine Datei __helpers/ez_on_rails/layout_helper.rb__.
Die Rückgabewerte der hier vorhandenen Methoden bestimmen Teile des Designs wie Beispielswiese
die Farbgebung. Diese können hier angepasst werden.

### Taggable Assoziationen
EzOnRails benutzt für die Darstellung von Assoziationen das select2 Feld.
Dieses ist in der Lage Optionen dynamisch hinzuzufügen, wenn sie noch nicht existieren.
Diese Option kann über die render_infos übergeben werden, indem die Klasse 'taggable' zugewiesen wird.
Es muss allerdings dann daran gedacht werden, dass in der entsprechenden Action die neuen Daten auch erstellt werden.
Die Übergabe der Klasse bewirkt lediglich, dass das select2 Feld den neuen Wert in das Feld einfügt.

```
  def render_info_example
    {
      tags: {
        label: 'Tags',
        html_options: {
          class: 'taggable'
        },
        label_method: :name
      }
    }
  end
```

### Neue Renderer für Attributtypen definieren
Im Ordner __helper/ez\_on\_rails/ez\_scaff/__ befinden sich Helper über die die Attribute zu Active records gerendsert werden.
Die Helper sind hier nach den Partialn benannt, in denen sie gerendert werden.
Es existieren demnach standardgemäß die ModelFormHelper, ShowHelper und IndexHelper.
In jedem dieser Helper kann für jeden Typ eine Methode geschrieben werden, die das entsprechende Attribut rendert.
Die Methode muss die Signatur der Form __render\_{type}\_{partial}(data, attribute\_key, attribute\_render\_info)__ haben.
Der erste Parameter _data_ ist dabei im Falle von :show und :index das Active Record Objekt.
Im Falle der :model\_form ist es der Form Builder.
In den Partials wird die Methode __attribute_render(attribute_key, attribute_render_info, target, data)__
aufgerufen. Diese identifiziert den Typ des Attributs und versucht die Methode zu finden, die zum Typ und übergenenen Ziel (Symbolischer Name des Partials) passt.
Wenn die Methode nicht gefunden wird, wird die jeweilige Default Methode des Helpers aufgerufen.

Wichtig ist zu beachten, dass sobald in den render_infos ein Typ definiert wird, dieser automatisch als Typ interpretiert wird.
Auf diese Weise können also Neue renderer einfach hinzugefügt werden, indem zum neuen Typ die entsprechenden Methoden ergänzt werden.

Es ist auch möglich ganz neue Partials zu entwickeln. In dem Partial muss dann nur die eben erwähnte __attribute_render__ Methode aufgerufen werden und 
als target muss diese den symbolischen Namen des neuen Partials erhalten. 
Natürlich muss der entsprehcnede Helper mit den entsprechenden Methoden vorhanden sein.

Im Helper kann dann noch die entsprechende __filter_attributes_{target}!(obj_class, render_info)__ Methode ergänzt werden.
Diese filtert diejenigen Attribute aus der übergebenen Render info, die nicht gezeigt werden sollen.

### Rekursive Breadcrumbs
EzOnRails sieht eine modulare Struktur mit Dashboards vor. Zum beispiel könnte es ein Modul Administration und Vertrieb geben.
Beide haben Dashboards die wiederum auf Seiten in den Modulen verweisen.
Breadcrumbs werden mittels Loaf erstellt. Diese werden zu Anfang in den Controllern über den Helper
_breadcrumb 'Titel', {controller: 'some_controller', action: 'some_action'}_ erstellt.
Dabei müssen in jedem Controller alle Breadcrumbs des Pfades angegeben werden. Existiert zum Beispiel im Modul Vertrieb eine Seite 
zum Drucken von Dokumenten, muss auf dieser Seite das Breadcrumb der Druckerseite UND des Verteiebs angegeben werden.
Das resultat ist copy-pasta code, denn jede Seite des Verteiebs muss das gleiche angeben.

Ein Workaround ist das aufbauen einer Vererbungshierarchie.
Im _ApplicationController_ sollte ein Breadcrumb zur Startseite gesetzt werden.
Dann sollten Controller erstellt werden, die von _ApplicationController_ erben und ebenso 
Breadcrumbs einbauen. Für jede Hierarchieebene muss ein solcher Controller erstellt werden, der von
dem Controller der nächst niedrigeren Hierarchie erbt. Die Controller der Seiten müssen
dann von dem Controller ihrer Hierarchie erben und ihre eigenen Breadcrumbs schreiben.
Somit sind es noch Application Controller, aber die Breadcrumbs müssen nicht erneut angegeben werden.

Beispiel (Schemenhaft):

```
# Enthält Breadcrumb auf Startseite
class ApplicationController 
    breadcrumb 'Startseite', root_path
end

# Enthält Breadcrumb auf Startseite und Dashboard 
class SalesDepartment::SalesDepartmentController < ApplicationController
    breadcrumb 'Vertrieb', {controller: '/sales_department/dashboard', action: 'index'}
end

# Enthält Bradcrumb auf Startseite und Dashboard
class SalesDepartment::DashboardController < SalesDepartment::SalesDepartmentController
    # actions
end 

# Enthält Breadcrumb auf Startseite, Dashboard und DocCreator
class SalesDepartment::DocCreator <  SalesDepartment::SalesDepartmentController
    breadcrumb 'Dokumente drucken', {controller: '/sales_department/doc_creator', action: 'index'}
end
```
 
### Nested Resources und Namespaces
In der Regel sollte EzOnRails mit einfach Nested-Resources zurecht kommen.
Wenn allerdings Nested-Resources in Namespaces existieren, löst Rails die polymorphen Pfade teilweise falsch auf.
Beispielsweise würde 
```
namespace :admin do
resources :users do
     resources :groups
end
end
```
zu Problemen führen, da der Rails-Helper __url\_for(obj)__ für ein Gruppen Objekt den Pfad mit 
:admin_users_admin_users_groups auflösen würde, was aber de-fakto falsch ist, da der Namespace rein formal gesehen
nur einmal um Groups herum existiert.
Es gibt aber einige Workarounds, die relativ einfach umzusetzen sind und sich gar nicht so schlimm anfühlen.

1. __shallow benutzen__
Im obigen Beispiel sollte das Stichwort shallow genutzt werden, sodass nur die nötigen Actions
nested sind. Siehe dazu die rails Dokumentation.
```
namespace :admin do
resources :users do
     resources :groups, shallow:true
end
end
```

2. __index filter benutzen__
Beim Aufruf einer nested-Resource befindet sich die ID des Parent-Elements in den parametermn.
Sie kann beispielsweise mit __params\[:user_id\]__ abgefragt werden.
Somit können die angezeigten Resourcen gefiltert werden. Anstelle aller Resourcen, sollten also nur die 
Resourcen des parent Elements gezogen werden.
```
Admin::Users::Groups.where(user_id: params[:user_id])
```

3. __create action ändern__
In der Create Action muss das Parent Element ausgelesen und dem Kindelement direkt zugewiesen werden.
```
user = Admin::Users::Groups.find(params[:user_id])
@admin_users_group.user = user
```

4. __custom urls in views benutzen__
In den Views der Resource sollten die im vorherigen Abschnitt erläuterten Custom-urls verwendet werden.
Diese müssen je nach bedarf angepasst werden. Dabei gilt zu beachten, dass im Falle einer nested Resource
die Rails Helper Parameter übernehmen können, zum Beispiel:

```
index_url: admin_groups_path(@admin_users_group.user),

```

5. __Breadcrumbs anpassen__
Die Breadcrumbs verlinkungen können zu Routing Fehlern führen und müssen ggf. Für jede Action angepasst werden.
 
### Verhindern des Löschens Benutzerabhängiger Resourcen
Standardgemäß wird eine Resource, die einem Benutzer gehört, gelöscht, wenn der Benutzer gelöscht wird.
Dieses verhalten kann unterbunden werden, indem im User-Model folgender Callback auskommentiert wird:
```
  #after_destroy :destroy_owned_resources
```

### Ein Paar Worte zu Turbolinks
Turbolinks wird in Rails automatisch als Gem mit installiert.
EzOnRails geht davon aus, dass es installiert ist.
Die Skripte in EzOnRails sind allerdings so gestaltet, dass es relativ einfach möglich ist diese zu verändern um
auch sicherzustellen, dass sie geladen werden wenn Turbolinks nicht verfügbar ist.
Im, ez_on_rails.coffee befindet sich eine funktion __onDocumentReady__ .
In diese sollten alle Funktionen geschrieben werden, die beim laden des Dokumentes normalerweise aufgerufen werden sollten.
EzOnRails lädt diese funktion im EVent für das Laden nach einem "Turbolink". Dieses müsste nur auf document.ready umgestellt werden
und schon funktioniert es.

### Weitere Sprachen hinzufügen
1. Dazu müssen die entsprechenden Übersetzungsdateien angelegt werden.
2. In der Datei __routes.rb__ muss das locale hinzugefügt werden. Dazu den Scope um die Applikation herum anpassen.
3. In der Datei __views/shared/_locale_switch__ muss um die neue Sprache ergänzt werden.

### Anzeige von Relationen begrenzen
Standardmäßig werden Relationen (sowohl Active Storage als auch normale) auf eine Anzahl begrenzt.
Die Begrenzung wird im __show_helper__ festgelegt. Wird diese Begrenzung überschritten,
wird ein details tag eingeblendet, der es ermöglicht alle Elemente anzuzeigen.
Die Anzahl der anzuzeigenden Elemente kann den render Infos als __:max_count__ mitgeteilt werden.
Dieses kann entweder ein Integer oder _:all_ sein. Bei _:all_ gibt es keine Begrenzung.

### Anmerkung zu CSRF Token
In der assets __application.coffee__ und webpackers __application.coffee_ werden für jeden Ajax Request als Default angehangenen Wert das aktuelle
CSRF Token aus dem Header gehangen.
Auf diese Weise sollten Ajax Requests in Rails funktionieren, ohne das man auf die Sicherheit durch CSRF Tokens verzichten muss.
Außerhalb von Forms funtkioniert diese herangehensweise immer.
Es wird ein initialiser erstellt, der Rails so konfiguriert, dass es für jeden Form Tag mittels eines Form Helpers einen Token erstellt.
Bisherige Tests ergaben, dass das im Formular erstelle Token das gleiche ist wie im Header. Somit sollte auch innerhalb eines Formulars
das Token funktionieren. Sollte dies einmal nicht der Fall sein, muss das hidden Field mit dem Token übergeben werden.

### Rubocop
EzOnRails kopiert einige Dateien der Anpassung wegen in das Verzeichnis der Rails Applikation.
Natürlich wurden diese Dateien mit Rubocop analysiert. Dabei wurden aber einige Anpassungen vorgenommen, da die Standard-Einstellungen von 
Rubocop etwas zu intenstiv sind.

Wir empfehlen die Benutzung von _rubocop-rspec_ und _rubocop-rails_.

Es wird folgende .rubocop.yml empfohlen:

```
require:
  - rubocop-rspec
  - rubocop-rails
AllCops:
  Exclude:
    - 'lib/generators/ez_on_rails/**/*/*_generator.rb' # not interested in checking the generators
    - bin/*
    - node_modules/**/*
    - db/migrate/**/*
    - db/schema.rb
    - test/**/*
    - tmp/**/*
    - vendor/**/*
    - config/initializers/**/* # most of the files here are auto generated, we do not want to check this
Metrics/LineLength:
  Max: 120
  Exclude:
    - 'config/initializers/devise.rb' # line length exceeds because of keys
Metrics/MethodLength:
  Max: 20
  Exclude:
    - 'app/helpers/**/*_helper.rb' # render_info and dash_info can be very large, hence we need to exclude helpers
    - 'spec/integration/api/**/*_spec.rb' # currently there is some bug in rswag, we need to define a method instead let for some reasons, thosw can be very huge
Metrics/ModuleLength:
  Exclude:
    - 'app/helpers/**/*_helper.rb' # render_info and dash_info can be very large, hence we need to exclude helpers
Style/DocumentationMethod:
  Enabled: true
Style/Documentation:
  Exclude:
    - app/helpers/application_helper.rb # Rails base application helper does not need to be commented
    - app/controllers/application_controller.rb # Rails base application controller does not need to be commented
    - app/models/application_record.rb # Rails base record does not need to be commented
    - config/application.rb # rails application config needs not to be commented
Style/ClassAndModuleChildren:
  EnforcedStyle: compact
  Exclude:
    - config/application.rb # for some reason the module is needed here, if it does not exists some generators may crash
Style/SymbolLiteral:
  Exclude:
    - spec/integration/**/*_spec.rb # integration specs need the :'Accept' header to check for http status 406 errors
Metrics/CyclomaticComplexity:
  Max: 10
Metrics/PerceivedComplexity:
  Max: 10
Metrics/AbcSize:
  Enabled: false
Rails/Exit:
  Exclude:
    - 'spec/rails_helper.rb' # rspec:install inserts exit, dont want to remove it because it is auto generated
Rails/Output:
  Exclude:
    - 'spec/rails_helper.rb' # inserts put, dont want to remove it because it is auto generated
Rails/HelperInstanceVariable:
  Exclude:
    - app/helpers/ez_on_rails/ez_app_helper.rb # uses @title and @subtitle to make it reachable to title and subtitle partial, this would be possible without instance variable but would result in massive code duplication
    - app/helpers/ez_on_rails/ez_paginator_renderer.rb # this is a paginator for will_paginate. html_options has to be passed in an instance method here. To be able to configure html_options from outside, they can be passed via constructor. Hence the instance variable is used to pass the html options to the method described before.
    - app/helpers/users_helper.rb # @minimum_password_length is used by devise
Metrics/BlockLength:
  Exclude:
    - config/routes.rb # namespaces are grouped in blocks, hence thosw can be very large
    - '**/*_spec.rb' # RSpec.describe is recognized as block...
    - 'spec/factories/**/*/' # Factory is recognized as block...
Style/MixinUsage:
  Exclude:
    - 'spec/factories/active_storage_attachments_factory.rb'
Layout/EmptyLinesAroundAccessModifier:
  Exclude:
    - 'app/helpers/**/*_helper.rb' # we use module function in dash helpers and menu structure helper because the generator needs to access the helper method, too. But the modules contain only one method. Hence surrounding module_function with spaces would collide with the rubocop detecting empty lines beyond module declarations.
RSpec/ExampleLength:
  Max: 20
RSpec/MultipleExpectations:
  Enabled: false # if you test some functionality that has multiple expections, you should not duplicate the whole test having all of its before hooks...
RSpec/LetSetup:
  Exclude:
    - 'spec/request//restricted_area_with_controller_and_action_spec.rb' # let! is used here to predefine the restricted areas
    - 'spec/request/ownership_info_access_spec.rb' # let! is used here to predefine the restricted resources
    - 'spec/system/admin/broom_closet/nil_owners_spec.rb' # let! is used here to predefine the restricted resources
    - 'spec/system/ownership_info_access_spec.rb' # let! is used here to predefine the restricted resources
RSpec/EmptyExampleGroup:
  Exclude:
    - 'spec/integration/api/**/*_spec.rb' # integration tests of api use rswag, which uses a special dsl
RSpec/DescribeClass:
  Exclude:
    - 'spec/integration/api/**/*_spec.rb' # integration tests of api use rswag, which uses a special dsl
RSpec/BeforeAfterAll:
  Exclude:
    - 'spec/system/admin/broom_closet/unattached_files_spec.rb' # atfer :all is used here to delete uploaded files
RSpec/InstanceVariable:
  Exclude:
    - 'spec/controllers/users/registrations_controller_spec.rb' # devise requires using @request instance variable here

```

### Benutzung von Namespaces in Controllern
EzOnRails wird im __ResourceController__ überall wo Symbole verwendet werden um die Resource zu identifizieren zunächst versuchen die namespaced Variante
zu erhalten.
Wird diese nicht gefunden, wird die nicht namespaced Variante versucht.

Beispiel: eine Resource __Admin::UserGroup__ würde normalerweise einen parameter __admin_group_id__ für diverse actions erwarten.
Solche Namen sind beim Coden natürlich nicht gerne gesehen.
Aus diesem grund kann man auch einfach __group_id__ verwenden.

### Default Permit überschreiben
Standardmäßig wird der __EzOnRails::ResourceController__ die Schlüssel seiner __render_info__ benutzen um 
Parameter zu permitten.

Die genutzte Methode kann hier genauso wie in den Views überschrieben werden, indem man im Controller eine Methode __permit_render_info__ 
deklariert.

Dies kann insbesondere dann sinnvoll sein, wenn das Model in einem Namespace liegt, man aber nicht möchte, dass der Name der __render_info__
Methode explodiert.

Der Resource Controller wird allerdings bei einer Namespaced Resource sowohl die Vairante mit, als auch ohne Namespace probieren,
sodass es hier nur für ganz spezielle Fälle erforderlich ist.

```
...
protected

def permit_render_info
    return 'render_info_short'
end
...
```

### Über normale Wege generierte Controller in EzOnRails einbinden
Wenn man die Generatoren von EzOnRails benutzt werden die Berechtigungs Routinen automatisch eingebunden.
Dies ist nicht der Fall, wenn die default Generatoren von Raiols verwendet werden.

Um auch diese Controller mit dem Funktionsumfang von EzOnRails auszustatten, müssen sie von __EzOnRails::ApplicationController__ erben.

```
class SomeController < EzOnRails::ApplicationController
  ...
end
```

Der __EzOnRails::ApplicationController__ wird vom __ApplicationController__ erben, sodass alle Feature des Controllers
der Applikation auch für alle EzOnRails Controller verfügbar sind.

### Logo Ausblenden
Per Default werden zwei Logos eingebunden.
Diese sind beide Optional. Man kann also auch nur ein Logo verwenden wenn man möchte.
Dazu muss lediglich das andere Logo aus dem Ordner entfernt werden.

### Default Locale Ändern
EzOnRails erstellt einen initializer für i18n.
Hier kann das default_locale geändert werden. Standardmäßig steht dieses auf :de.

### Active Storage aus JavaScript heraus
Um einen direct Upload aus nicht-Rails Apps wie Beispielsweise React zu ermöglichen, und um die Komponente der Dropzone die mit EzOnRails mitgeliefert wird
zum laufen zu bekommen, wurden extra actions eingebaut, um den Upload zu ermöglichen.
Die default Actions von Rails gehen leider nur davon aus, dass ein authenticity Token genügt.
Da wir aber hier auch API Aufrufe haben müssen wir ggf. eine Authentifikation via Token haben.
Die Actions die mitgeliefert werden, werden über die Seeds zunächst automatiscch nur für den SuperAdmin zugänglich.

Im Javascript muss dann active storage direct upload ein delegate übergeben werden, um die Headerinformationen zu ergänzen:

```
  let upload = new ActiveStorage.DirectUpload(acceptedFile, toFullBackendUrl('api/active_storage/blobs'), {
        directUploadWillCreateBlobWithXHR: (request: XMLHttpRequest) => {
            const httpHeader:any = EzOnRails.http.client.defaultHttpHeader(props.authInfo)
    
            Object.keys(httpHeader).forEach((key) => {
                request.setRequestHeader(key, httpHeader[key])
            })
    
            request.upload.addEventListener("progress", onDirectUploadProgress);
        }
    });
    
    upload.create((error, blob) => {
        // if some error occurs, just print it to the console and do nothing else
        if (error) {
            console.log("Image Error:", error);
            setUploadsInProgress(uploadsInProgress - 1)
        }
        else {
        ...
        }
    })
```

Die Funktion defaultHttpHeader stammt aus dem ez-on-rails-react npm package.