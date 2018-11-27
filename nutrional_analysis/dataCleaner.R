setwd("~/Desktop/FoodApp")

food_desc = read.delim(file='sr28asc/FOOD_DES.txt', quote = '~', sep = '^', header=F, col.names = c('ndb_no','fdgrp_cd','long_desc',
                                                                                                    'short_desc','company_name','manufacture_name',
                                                                                                    'survey_indic','refuse_desc','refuse_percent',
                                                                                                    'science_name', 'nitrogen_to_protien_factor','protien_to_kcal_factor',
                                                                                                    'kcal_to_fat_factor', 'carb_to_kcal_factor'))

food_groups = read.delim(file='sr28asc/FD_GROUP_v2.txt', quote='~', sep='^', header=F, col.names = c('fdgrp_cd', 'fdgrp_desc', 'fdgrp_descS'))
langual_codes = read.delim(file='sr28asc/LANGUAL.txt', quote='~', sep='^', header=F, col.names = c('ndb_no','factor_code'))
langual_desc =  read.delim(file='sr28asc/LANGUAL.txt', quote='~', sep='^', header=F, col.names = c('factor_code','langual_desc'))

nutrition_data = read.delim(file='sr28asc/NUT_DATA.txt', quote='~', sep='^', header=F, col.names = c('ndb_no','nutr_no','nutr_val',
                                                                                                     'num_data_pts','std_error','src_cd',
                                                                                                     'deriv_cd','reference_ndb_no','add_nutr_ind',
                                                                                                     'num_of_studies','min_val','max_val','degrees_of_freedom',
                                                                                                     'lower_error_bound_95','upper_error_bound_95','stats_cmts',
                                                                                                     'addmod_date','confidence_code'))

nutrition_def = read.delim(file='sr28asc/NUTR_DEF_v2.txt', quote='~', sep='^', header=F, col.names = c('nutr_no','units','tag_name',
                                                                                                    'nutr_desc', 'num_dec','sr_order'))

source_codes = read.delim(file='sr28asc/SRC_CD.txt', quote='~', sep='^', header=F, col.names = c('src_cd','src_desc'))

derivation_data = read.delim(file='sr28asc/DERIV_CD.txt', quote='~', sep='^', header=F, col.names = c('deriv_cd','deric_desc'))

weight_data = read.delim(file = 'sr28asc/WEIGHT.txt', quote = '~', sep = '^', header = F, col.names =c('ndb_no','sequence','amount','measure_desc','gram_weight',
                                                                                                       'num_data_pts','std_dev'))

footnote = read.delim(file = 'sr28asc/FOOTNOTE.txt', quote = '~', sep = '^', header = F, col.names =c('ndb_no','footnote_no','footnote_typ',
                                                                                                      'nutr_no','footnote_txt'))

source_datalink = read.delim(file='sr28asc/DATSRCLN.txt', quote='~', sep='^', header=F, col.names = c('ndb_no','nutr_no', 'data_src_id'))


data_source = read.delim(file = 'sr28asc/DATA_SRC.txt', quote = '~', sep='^', header = F, col.names = c('data_src_id', 'author', 'title',
                                                                                                        'year',' journal','volume_city',
                                                                                                        'issue_no_state','start_page', 'end_page'))

