##here we need to pull all the metadata from all the marked photos so we can use it to have our photos show on the leaflet map
# source('R/packages.R')


# define your project repo name
repo_name <- 'fish_passage_bulkley_2022_reporting'

photo_metadata_prep <- exifr::read_exif('data/photos',recursive=T)  %>%
  janitor::clean_names() %>%
  select(file_name, source_file, gps_latitude, gps_longitude) %>%
  mutate(url  = paste0('https://github.com/NewGraphEnvironment/', repo_name, '/raw/master/',
                       source_file)) %>%
  # base = tools::file_path_sans_ext(filename)) %>%
  filter(
    file_name %like% '_k_'
  )

mw_photos <- photo_metadata_prep %>%
  filter(source_file %like% 'TimePhoto') %>%
  mutate(gps_latitude = case_when(source_file %like% '114509_k_d1_' ~ '54.441709',
                                  source_file %like% '123348_k_d2_' ~ '54.439974',
                                  source_file %like% '111004_d1_k_' ~ '54.517951',
                                  source_file %like% '112035_d2_k_' ~ '54.517691',
                                  source_file %like% '130817_u1_k_' ~ '54.521282',
                                  source_file %like% '135504_u2_k_' ~ '54.524203',
                                  source_file %like% '160737_d1_k_' ~ '54.476037',
                                  source_file %like% '164017_d2_k_' ~ '54.475146',
                                  source_file %like% '105045_d1_k_' ~ '54.525418',
                                  source_file %like% '110856_d2_k_' ~ '54.52543',
                                  source_file %like% '111946_u1_k_' ~ '54.970603',
                                  source_file %like% '112702_u2_k_' ~ '54.970282',
                                  source_file %like% '114854_u3_k_' ~ '54.969563',
                                  source_file %like% '123306_u4_k_' ~ '54.971944')) %>%

  mutate(gps_longitude = case_when(source_file %like% '114509_k_d1_' ~ '-126.757459',
                                   source_file %like% '123348_k_d2_' ~ '-126.759404',
                                   source_file %like% '111004_d1_k_' ~ '-126.442873',
                                   source_file %like% '112035_d2_k_' ~ '-126.442904',
                                   source_file %like% '130817_u1_k_' ~ '-126.443963',
                                   source_file %like% '135504_u2_k_' ~ '-126.446454',
                                   source_file %like% '160737_d1_k_' ~ '-126.216286',
                                   source_file %like% '164017_d2_k_' ~ '-126.216239',
                                   source_file %like% '105045_d1_k_' ~ '-126.816823',
                                   source_file %like% '110856_d2_k_' ~ '-126.818522',
                                   source_file %like% '111946_u1_k_' ~ '-127.285463',
                                   source_file %like% '112702_u2_k_' ~ '-127.284336',
                                   source_file %like% '114854_u3_k_' ~ '-127.28243',
                                   source_file %like% '123306_u4_k_' ~ '-127.276703'))

photo_metadata <- photo_metadata_prep %>%
  filter(!source_file %like% 'TimePhoto') %>%
  bind_rows(mw_photos)


conn <- rws_connect("data/bcfishpass.sqlite")
rws_list_tables(conn)
rws_drop_table("photo_metadata", conn = conn) ##now drop the table so you can replace it
rws_write(photo_metadata, exists = F, delete = TRUE,
          conn = conn, x_name = "photo_metadata")
rws_list_tables(conn)
rws_disconnect(conn)

