# Copyright © Mapotempo, 2015-2016
#
# This file is part of Mapotempo.
#
# Mapotempo is free software. You can redistribute it and/or
# modify since you respect the terms of the GNU Affero General
# Public License as published by the Free Software Foundation,
# either version 3 of the License, or (at your option) any later version.
#
# Mapotempo is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the Licenses for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Mapotempo. If not, see:
# <http://www.gnu.org/licenses/agpl.html>
#
require 'active_support'
require 'tmpdir'

require './wrappers/crow'
require './wrappers/osrm5'
require './wrappers/otp'
require './wrappers/here'

require './lib/cache_manager'

module RouterWrapper
  ActiveSupport::Cache.lookup_store :redis_store
  CACHE = CacheManager.new(ActiveSupport::Cache::RedisStore.new(host: ENV['REDIS_HOST'] || 'localhost', namespace: 'router', expires_in: 60*60*24*1, raise_errors: true))

  CROW = Wrappers::Crow.new(CACHE)
  OSRM_CAR_EUROPE = Wrappers::Osrm5.new(CACHE, url_time: 'http://osrm-car-europe:5000', url_distance: 'http://osrm-car-france-distance:5000', url_isochrone: 'http://osrm-car-europe:1723', url_isodistance: 'http://osrm-car-france-distance:1723', track: true, toll: true, motorway: true, licence: 'ODbL', attribution: '© OpenStreetMap contributors', area: 'Europe', boundary: 'poly/europe.kml')
  OSRM_CAR_FRANCE_OVERSEA = Wrappers::Osrm5.new(CACHE, url_time: 'http://osrm-car-overseas:5000', url_distance: nil, url_isochrone: 'http://osrm-car-overseas:1723', url_isodistance: nil, licence: 'ODbL', attribution: '© OpenStreetMap contributors', area: 'France Oversea', boundary: 'poly/france-oversea.kml')
  OSRM_TRUCK_MEDIUM = Wrappers::Osrm5.new(CACHE, url_time: 'http://osrm-truck-medium-france:5000', url_distance: nil, url_isochrone: 'http://osrm-truck-medium-france:1723', url_isodistance: nil, track: true, toll: true, motorway: true, licence: 'ODbL', attribution: '© OpenStreetMap contributors')
  OSRM_PEDESTRIAN_FRANCE = Wrappers::Osrm5.new(CACHE, url_time: 'http://osrm-foot-france:5000', url_isochrone: 'http://osrm-foot-france:1723', licence: 'ODbL', attribution: '© OpenStreetMap contributors', area: 'France')
  OSRM_CYCLE_FRANCE = Wrappers::Osrm5.new(CACHE, url_time: 'http://osrm-bicycle-france:5000', url_isochrone: 'http://osrm-bicycle-france:1723', licence: 'ODbL', attribution: '© OpenStreetMap contributors', area: 'France')
  # tmp
  OSRM_CAR_INTERURBAN_USA_NE = Wrappers::Osrm5.new(CACHE, url_time: 'http://delta.mapotempo.com:5001', url_distance: nil, url_isochrone: nil, url_isodistance: nil, licence: 'ODbL', attribution: '© OpenStreetMap contributors', area: 'US Northeast', boundary: 'poly/us-east-coast.kml')
  OSRM_CAR_INTERURBAN_QUEBEC = Wrappers::Osrm5.new(CACHE, url_time: 'http://delta.mapotempo.com:5002', url_distance: nil, url_isochrone: nil, url_isodistance: nil, licence: 'ODbL', attribution: '© OpenStreetMap contributors', area: 'Quebec', boundary: 'poly/quebec.kml')
  OSRM_CAR_INTERURBAN_TEXAS = Wrappers::Osrm5.new(CACHE, url_time: 'http://delta.mapotempo.com:5003', url_distance: nil, url_isochrone: nil, url_isodistance: nil, licence: 'ODbL', attribution: '© OpenStreetMap contributors', area: 'US Texas', boundary: 'poly/texas.kml')
  OSRM_CAR_INTERURBAN_COLORADO = Wrappers::Osrm5.new(CACHE, url_time: 'http://delta.mapotempo.com:5006', url_distance: nil, url_isochrone: nil, url_isodistance: nil, licence: 'ODbL', attribution: '© OpenStreetMap contributors', area: 'US Colorado', boundary: 'poly/colorado.kml')
  OSRM_CAR_INTERURBAN_ILLINOIS = Wrappers::Osrm5.new(CACHE, url_time: 'http://delta.mapotempo.com:5007', url_distance: nil, url_isochrone: nil, url_isodistance: nil, licence: 'ODbL', attribution: '© OpenStreetMap contributors', area: 'US Illinois', boundary: 'poly/illinois.kml')
  OSRM_CAR_INTERURBAN_MAGHREB = Wrappers::Osrm5.new(CACHE, url_time: 'http://delta.mapotempo.com:5004', url_distance: nil, url_isochrone: nil, url_isodistance: nil, licence: 'ODbL', attribution: '© OpenStreetMap contributors', area: 'Morooco, Algeria, Tunisia', boundary: 'poly/maghreb.kml')
  OSRM_CAR_INTERURBAN_SOUTH_AFRICA = Wrappers::Osrm5.new(CACHE, url_time: 'http://delta.mapotempo.com:5005', url_distance: nil, url_isochrone: nil, url_isodistance: nil, licence: 'ODbL', attribution: '© OpenStreetMap contributors', area: 'South-Africa', boundary: 'poly/south-africa-and-lesotho.kml')
  OSRM_CAR_INTERURBAN_GCC = Wrappers::Osrm5.new(CACHE, url_time: 'http://delta.mapotempo.com:5011', url_distance: nil, url_isochrone: nil, url_isodistance: nil, licence: 'ODbL', attribution: '© OpenStreetMap contributors', area: 'GCC', boundary: 'poly/gcc.kml')
  OSRM_CAR_URBAN_USA_NE = Wrappers::Osrm5.new(CACHE, url_time: 'http://delta.mapotempo.com:5101', url_distance: nil, url_isochrone: nil, url_isodistance: nil, licence: 'ODbL', attribution: '© OpenStreetMap contributors', area: 'US Northeast', boundary: 'poly/us-east-coast.kml')
  OSRM_CAR_URBAN_QUEBEC = Wrappers::Osrm5.new(CACHE, url_time: 'http://delta.mapotempo.com:5102', url_distance: nil, url_isochrone: nil, url_isodistance: nil, licence: 'ODbL', attribution: '© OpenStreetMap contributors', area: 'Quebec', boundary: 'poly/quebec.kml')
  OSRM_CAR_URBAN_TEXAS = Wrappers::Osrm5.new(CACHE, url_time: 'http://delta.mapotempo.com:5103', url_distance: nil, url_isochrone: nil, url_isodistance: nil, licence: 'ODbL', attribution: '© OpenStreetMap contributors', area: 'US Texas', boundary: 'poly/texas.kml')
  OSRM_CAR_URBAN_COLORADO = Wrappers::Osrm5.new(CACHE, url_time: 'http://delta.mapotempo.com:5106', url_distance: nil, url_isochrone: nil, url_isodistance: nil, licence: 'ODbL', attribution: '© OpenStreetMap contributors', area: 'US Colorado', boundary: 'poly/colorado.kml')
  OSRM_CAR_URBAN_ILLINOIS = Wrappers::Osrm5.new(CACHE, url_time: 'http://delta.mapotempo.com:5107', url_distance: nil, url_isochrone: nil, url_isodistance: nil, licence: 'ODbL', attribution: '© OpenStreetMap contributors', area: 'US Illinois', boundary: 'poly/illinois.kml')
  OSRM_CAR_URBAN_MAGHREB = Wrappers::Osrm5.new(CACHE, url_time: 'http://delta.mapotempo.com:5104', url_distance: nil, url_isochrone: nil, url_isodistance: nil, licence: 'ODbL', attribution: '© OpenStreetMap contributors', area: 'Morooco, Algeria, Tunisia', boundary: 'poly/maghreb.kml')
  OSRM_CAR_URBAN_INDONESIA = Wrappers::Osrm5.new(CACHE, url_time: 'http://delta.mapotempo.com:5108', url_distance: nil, url_isochrone: nil, url_isodistance: nil, licence: 'ODbL', attribution: '© OpenStreetMap contributors', area: 'Indonesia', boundary: 'poly/indonesia.kml')
  OSRM_CAR_URBAN_AUSTRALIA = Wrappers::Osrm5.new(CACHE, url_time: 'http://delta.mapotempo.com:5109', url_distance: nil, url_isochrone: nil, url_isodistance: nil, licence: 'ODbL', attribution: '© OpenStreetMap contributors', area: 'Australia', boundary: 'poly/australia.kml')
  OSRM_CAR_URBAN_SENEGAL = Wrappers::Osrm5.new(CACHE, url_time: 'http://delta.mapotempo.com:5110', url_distance: nil, url_isochrone: nil, url_isodistance: nil, licence: 'ODbL', attribution: '© OpenStreetMap contributors', area: 'Senegal', boundary: 'poly/senegal-and-gambia.kml')
  OSRM_CAR_URBAN_GCC = Wrappers::Osrm5.new(CACHE, url_time: 'http://delta.mapotempo.com:5111', url_distance: nil, url_isochrone: nil, url_isodistance: nil, licence: 'ODbL', attribution: '© OpenStreetMap contributors', area: 'GCC', boundary: 'poly/gcc.kml')
  OSRM_CAR_URBAN_IRAN = Wrappers::Osrm5.new(CACHE, url_time: 'http://delta.mapotempo.com:5112', url_distance: nil, url_isochrone: nil, url_isodistance: nil, licence: 'ODbL', attribution: '© OpenStreetMap contributors', area: 'Iran', boundary: 'poly/iran.kml')
  OSRM_CAR_URBAN_MYANMAR = Wrappers::Osrm5.new(CACHE, url_time: 'http://delta.mapotempo.com:5113', url_distance: nil, url_isochrone: nil, url_isodistance: nil, licence: 'ODbL', attribution: '© OpenStreetMap contributors', area: 'Myanmar', boundary: 'poly/myanmar.kml')
  OSRM_CAR_URBAN_ARGENTINA = Wrappers::Osrm5.new(CACHE, url_time: 'http://delta.mapotempo.com:5114', url_distance: nil, url_isochrone: nil, url_isodistance: nil, licence: 'ODbL', attribution: '© OpenStreetMap contributors', area: 'Argentina', boundary: 'poly/argentina.kml')

  OSRM_CAR = [
    OSRM_CAR_EUROPE,
    OSRM_CAR_FRANCE_OVERSEA,
  ]

  OSRM_CAR_INTERURBAN = [
    OSRM_CAR_INTERURBAN_USA_NE,
    OSRM_CAR_INTERURBAN_QUEBEC,
    OSRM_CAR_INTERURBAN_TEXAS,
    OSRM_CAR_INTERURBAN_COLORADO,
    OSRM_CAR_INTERURBAN_ILLINOIS,
    OSRM_CAR_INTERURBAN_MAGHREB,
    OSRM_CAR_INTERURBAN_SOUTH_AFRICA,
    OSRM_CAR_INTERURBAN_GCC,
  ]

  OSRM_CAR_URBAN = [
    OSRM_CAR_URBAN_USA_NE,
    OSRM_CAR_URBAN_QUEBEC,
    OSRM_CAR_URBAN_TEXAS,
    OSRM_CAR_URBAN_COLORADO,
    OSRM_CAR_URBAN_ILLINOIS,
    OSRM_CAR_URBAN_MAGHREB,
    OSRM_CAR_URBAN_INDONESIA,
    OSRM_CAR_URBAN_AUSTRALIA,
    OSRM_CAR_URBAN_SENEGAL,
    OSRM_CAR_URBAN_GCC,
    OSRM_CAR_URBAN_IRAN,
    OSRM_CAR_URBAN_MYANMAR,
    OSRM_CAR_URBAN_ARGENTINA,
  ]

  OTP = {
    bordeaux: {licence: 'ODbL', attribution: 'Bordeaux Métropole', area: 'Bordeaux, France', boundary: 'poly/france-bordeaux.kml', crs: 'EPSG:2154'},
    nantes: {licence: 'ODbL', attribution: 'Nantes Métropole', area: 'Nantes, France', boundary: 'poly/france-nantes.kml', crs: 'EPSG:2154'},
    toulouse: {licence: 'ODbL', attribution: 'Tisséo', area: 'Toulouse, France', boundary: 'poly/france-toulouse.kml', crs: 'EPSG:2154'},
    metz: {licence: 'LO', attribution: 'Metz Métropole', area: 'Metz, France', boundary: 'poly/france-metz.kml', crs: 'EPSG:2154'},
    nancy: {licence: 'ODbL', attribution: 'Communauté Urbaine du Grand Nancy', area: 'Nancy, France', boundary: 'poly/france-nancy.kml', crs: 'EPSG:2154'},
    rennes: {licence: 'ODbL', attribution: 'STAR', area: 'Rennes, France', boundary: 'poly/france-rennes.kml', crs: 'EPSG:2154'},
    strasbourg: {licence: '', attribution: 'Compagnie des Transports Strasbourgeois', area: 'Strasbourg, France', boundary: 'poly/france-strasbourg.kml', crs: 'EPSG:2154'},
    idf: {licence: 'ODbL', attribution: 'STIF', area: 'Île-de-France, France', boundary: 'poly/france-idf.kml', crs: 'EPSG:2154'},
    grenoble: {licence: 'ODbL', attribution: 'Grenoble Alpes Métropole', area: 'Grenoble, France', boundary: 'poly/france-grenoble.kml', crs: 'EPSG:2154'},
    marseille: {licence: 'ODbL', attribution: 'Syndicat Mixte des Transports des Bouches-du-Rhône', area: 'Marseille, France', boundary: 'poly/france-marseille.kml', crs: 'EPSG:2154'},
    nice: {licence: 'LO', attribution: 'Régie Ligne d''Azur', area: 'Nice, France', boundary: 'poly/france-nice.kml', crs: 'EPSG:2154'},
    brest: {licence: 'LO', attribution: 'Bibus Brest Métropole', area: 'Brest, France', boundary: 'poly/france-brest.kml', crs: 'EPSG:2154'},
    poitiers: {licence: 'ODbL', attribution: 'Grand Poitiers', area: 'Poitiers, France', boundary: 'poly/france-poitiers.kml', crs: 'EPSG:2154'},
    lille: {licence: 'LO', attribution: 'Lille Métropole', area: 'Lille, France', boundary: 'poly/france-lille.kml', crs: 'EPSG:2154'},
  }.collect{ |k, v|
    Wrappers::Otp.new(CACHE, v.merge(url: "http://otp-#{k.to_s}:7000", router_id: k.to_s))
  }

  HERE_APP_ID = 'yihiGwg1ibLi0q6BfBOa'
  HERE_APP_CODE = '5GEGWZnjPAA-ZIwc7DF3Mw'
  HERE_TRUCK = Wrappers::Here.new(CACHE, app_id: HERE_APP_ID, app_code: HERE_APP_CODE, mode: 'truck')

  @@c = {
    product_title: 'Router Wrapper API',
    product_contact_email: 'tech@mapotempo.com',
    product_contact_url: 'https://github.com/Mapotempo/router-wrapper',
    profiles: [{
      # Car as car2, Apologic only
      api_keys: [
        'apologic-1-9f9f5d62b4c32ce08f7f1bd144133e088f59c445',
        'apologic-beta-79728b4dbd59e080d36ba862d592d694',
      ],
      services: {
        route_default: :car,
        route: {
          car: OSRM_CAR,
          car2: OSRM_CAR,
          pedestrian: [OSRM_PEDESTRIAN_FRANCE],
          cycle: [OSRM_CYCLE_FRANCE],
          public_transport: OTP,
          crow: [CROW],
        },
        matrix: {
          car: OSRM_CAR,
          car2: OSRM_CAR,
          pedestrian: [OSRM_PEDESTRIAN_FRANCE],
          cycle: [OSRM_CYCLE_FRANCE],
          public_transport: OTP,
          crow: [CROW],
        },
        isoline: {
          car: OSRM_CAR,
          car2: OSRM_CAR,
          pedestrian: [OSRM_PEDESTRIAN_FRANCE],
          cycle: [OSRM_CYCLE_FRANCE],
          public_transport: OTP,
          crow: [CROW],
        }
      }
    }, {
      # Car
      api_keys: [
        'demo',
        'baldr-test-1-iosengoh3Oi2Iehiquoh7ieGhee2eewe',
        'hardis-test-1-ApukaMei6eicuja6ooha0juceeHeek2o',
        'aplus-test-1-as8nee1aiPhiGhoox9Soow1Chai0eiVo',
        'cc3i-test-1-ipeegh2iaka4waiJ8uchielahnapeiv6',
        'cofisoft-test-1-efokumeem4Bi6hu8su4vahn1gi0woov5',
        'galigeo-test-1-Ci9ith7qui5Quotohreotih5joohaise',
        'alyacom-test-e2f5c1a84d810f6a9a7cb6ba969300dab6324c16a1f496e389953f67',
        'admr-test-1-3ba76b0f79c1a8517a9d3d101dcbd837',
        'adsi-test-1-Vah3aiy2chaeYaikaeK9ohGh5Aequ1ah',
        'processfirst-test-1-oa3Ohgookei2yee5Naila2ieY9isohru',
        'inlecom-1-pe3io4Ui5aimobich1oot0eilothongo', # SELIS
        'chronolink-test-1-Oi9sun5Yee5iNiava2feif0yaechuoTh',
        'danem-test-1-ooy4Zoomahzad2ain8jahPaikieraire',
        'ulb-1-johm6ef7shaRaem6ue5aeDah8sise4op', # SELIS
      ],
      services: {
        route_default: :car,
        route: {
          car: OSRM_CAR,
          truck_medium: [OSRM_TRUCK_MEDIUM],
          pedestrian: [OSRM_PEDESTRIAN_FRANCE],
          cycle: [OSRM_CYCLE_FRANCE],
          public_transport: OTP,
          crow: [CROW],
        },
        matrix: {
          car: OSRM_CAR,
          truck_medium: [OSRM_TRUCK_MEDIUM],
          pedestrian: [OSRM_PEDESTRIAN_FRANCE],
          cycle: [OSRM_CYCLE_FRANCE],
          public_transport: OTP,
          crow: [CROW],
        },
        isoline: {
          car: OSRM_CAR,
          truck_medium: [OSRM_TRUCK_MEDIUM],
          pedestrian: [OSRM_PEDESTRIAN_FRANCE],
          cycle: [OSRM_CYCLE_FRANCE],
          public_transport: OTP,
          crow: [CROW],
        }
      }
    }, {
      # Car + Truck
      api_keys: [
        'mapotempo-web-1-d701e4a905fbd3c8d0600a2af433db8b',
        'mapotempo-web-beta-d701e4a905fbd3c8d0600a2af433db8b',
        'althea-test-e056ea36866a81665c51070b9bbc323164',
        'michelin-innovation-test-1-SaecheeChooleeghuHai1EikieyeiN5p',
        'transalliance-test-1-XohjeeD0aghaamoh3uwo7Ieseew8diet',
        'microtrans-test-1-gee0aewishohSh1Ceeja4Poulahgheiy',
        'kratzer-test-1-rieyohy9Hu1Iecei6weiph5rehee5Jei',
        'urios-test-1-97a6df314147dadea67b64c80f8d5494',
        'waplanner-test-1-zaa5cha8zee9ChaiKae3quoonee1hiej',
        'sabenis-test-1-c8eet5ooRaeghahX3Aroofahjahk3nue',
        'mobix-test-1-eeTeaw1ra2fi4AiC7abo0AiDae7loqui',
        'ikos-1-ahjocu9Foh1ta4uw3poojebi0guu9egh', # IKOS / LHOTELLIER - etic-studio
      ],
      services: {
        route_default: :car,
        route: {
          car: OSRM_CAR,
          truck_medium: [OSRM_TRUCK_MEDIUM],
          car_interurban: OSRM_CAR_INTERURBAN,
          car_urban: OSRM_CAR_URBAN,
          pedestrian: [OSRM_PEDESTRIAN_FRANCE],
          cycle: [OSRM_CYCLE_FRANCE],
          public_transport: OTP,
          crow: [CROW],
          truck: [HERE_TRUCK],
        },
        matrix: {
          car: OSRM_CAR,
          truck_medium: [OSRM_TRUCK_MEDIUM],
          car_interurban: OSRM_CAR_INTERURBAN,
          car_urban: OSRM_CAR_URBAN,
          pedestrian: [OSRM_PEDESTRIAN_FRANCE],
          cycle: [OSRM_CYCLE_FRANCE],
          public_transport: OTP,
          crow: [CROW],
          truck: [HERE_TRUCK],
        },
        isoline: {
          car: OSRM_CAR,
          truck_medium: [OSRM_TRUCK_MEDIUM],
          car_interurban: [],
          car_urban: [],
          pedestrian: [OSRM_PEDESTRIAN_FRANCE],
          cycle: [OSRM_CYCLE_FRANCE],
          public_transport: OTP,
          crow: [CROW],
          truck: [HERE_TRUCK],
        }
      }
    }]
  }

  @@c[:api_keys] = Hash[@@c[:profiles].collect{ |profile|
    profile[:api_keys].collect{ |api_key|
      [api_key, profile[:services]]
    }
  }.flatten(1)]
end
