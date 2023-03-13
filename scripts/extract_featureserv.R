library(pgfeatureserv)
library(tidyverse)

# ----------------new graph development server (PG_DB_DO is production) ---------------------------------

base_url <- "http://www.a11s.one:9000/"

path <- ""
collection_id <- "bcfishpass.crossings"


# I can only figure out how to do one watershed group at a time so we may need to `bind_rows` to add CRKD and CARP which shoudl be added
bcfishpass <- pgfeatureserv::pgf_collection_features(collection_id, base_url = base_url, path = path,
                                                  filter = list(watershed_group_code = "PARS"))

# see the datasets available through the api
collections <- pgfeatureserv::pgf_collections(base_url = base_url, path = path)


