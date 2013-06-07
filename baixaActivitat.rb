#! /usr/bin/env ruby
# encoding: utf-8

=begin
Aquest guió serveix per baixar
tots els arxius d'una tasca del Moodle
Paràmetres mòdul nomtasca
Ex. crida arxiusTasca M4 ExamenUF2RA02
=end
require 'pathname'
require 'mechanize'

#Constants per accedir al Moodle
campus_url = "http://iesriberabaixa.cat/campusvirtual"
login_url = "login/index.php"
username = "sergipd"
password = "2012elprat2013"

#Recollim dades de la tasca
puts "Quin mòdul és?"
modul = gets.chomp
modul = "M#{modul}"
puts "Quina tasca?"
nomtasca = gets.chomp

campus_uri = Pathname.new(campus_url)
login_uri = campus_uri.join(login_url)

scraper = Mechanize.new
scraper.get(login_uri) do |page|
  #Per pintar la pàgina HTML que ens està 
  #puts  page.search('/').to_xml
  # Investigant la pàgina de login es veu que el formulari de login
  # té com a `action` la mateixa URI que a la que estem accedint.
  # El camp de nom d'usuari s'anomena `username` i el camp de contrasenya
  # `password`.
  #
  # Per tant, seleccionem el formulari pel seu `action`, assignem el primer
  # argument al camp `username` i el segon al camp `password`. Finalment
  # executem el submit del formulari que ens autentica al Moodle.
  #
  # Assignant el resultat de l'autenticació a la variable `main_page` ens assegura
  # que podem seguir la navegació a partir d'aquí.
  main_page = page.form_with(:action => login_uri.to_s) do |f|
    f.username = username
    f.password = password
  end.submit

#3Entrem a la pàgina del taller
  # Seleccionem l'enllaç amb el text començant per “Ruby” i assignem la pàgina resultant
  # a la variable ruby.
  course = main_page.links.find { |link| link.text.match(/#{modul}/) }.click

#4Entrem als documents 
  # Seleccionem l'enllaç amb el text “Fitxers” i assignem la pàgina resultant
  # a la variable `m4_files`.
 tasca = course.links.find { |link| link.text.match(/#{nomtasca}/) }.click
course_files = tasca.links.find { |link| link.text.match(/Visualitza/) }.click

  # Generem un Array on cada element és un Hash amb la forma:
  #     {
  #       :name => nom_del_fitxer,
  #       :url => url_del_fitxer,
  #       :size => tamany_del_fitxer,
  #       :date => data_de_modificació
  #     }
  files = course_files.search('//div[@class = "files"]/a/@href').map do |row| 
    {
   	# elimina el primer caràcter, un esai (U+160) que no elimina el mètode strip
      :id => row.to_s.strip.slice(row.to_s.strip.rindex("/",-(+1+row.to_s.strip.length-row.to_s.strip.rindex("/")))+1,row.to_s.strip.rindex("/")-row.to_s.strip.rindex("/",-(+1+row.to_s.strip.length-row.to_s.strip.rindex("/")))-1),
      :url => row.to_s.strip
    }
  end
#=begin
  noms = Hash.new
  course_files.search('//table/tr[@class="r0"]|//table/tr[@class="r1"]').each do |row| 
    
   	# elimina el primer caràcter, un esai (U+160) que no elimina el mètode strip
noms[row.search('td[@class="cell c0 picture"]/a/@href').to_s.strip.slice(row.search('td[@class="cell c0 picture"]/a/@href').to_s.strip.index("id=")+3,row.search('td[@class="cell c0 picture"]/a/@href').to_s.strip.index("&")-(row.search('td[@class="cell c0 picture"]/a/@href').to_s.strip.index("id=")+3))] = row.search('td[@class="cell c1 fullname"]/a').first.content.strip      	
    
  end
#=end 

  # @@TODO@@ Fem quelom amb els fitxers
  # mkdir -p (només el crea si no existeix)	
  
  directori = "#{modul} #{nomtasca}"
  FileUtils.mkdir_p directori
  #files.each = for i = file
  files.each do |file|
    nomarxiu = noms[file[:id]]
    scraper.get(file[:url]).save(Pathname.new(directori).join(nomarxiu))
    #Pathname.new('downloads').join(file[:name]).rename(noms[file[:name]]) 	
  end
end
