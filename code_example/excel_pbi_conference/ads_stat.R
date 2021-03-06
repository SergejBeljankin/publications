# ��������� ������
install.packages('rvkstat')

# ����������� �������
library(rvkstat)
library(dplyr)
library(tidyr)

# ������������ ����������
browseURL('https://vk.com/apps?act=manage')

# �������� �����������
vkauth <- vkAuth() 

# ��������� ���������� ������ � ����
saveRDS(object = vkauth, "C:/vkauth/vkauth.rds")

# ####################################
# ������ ��������� ���������
accounts <- vkGetAdAccounts(vkauth$access_token)

## �������� ������ ��������� ��������
camp <- vkGetAdCampaigns(account_id   = 1600134264,
                         access_token = vkauth$access_token)

vk_stat_by_campaign <- vkGetAdStatistics(
    account_id   = 1600134264,
    ids_type     = "campaign",
    ids          = camp$id ,
    period       = "day",
    date_from    = "2010-01-01",
    date_to      = Sys.Date(),
    access_token = vkauth$access_token)


## �������� ������ ��������� ��������
ads <- vkGetAds(account_id = 1600134264, 
                access_token = vkauth$access_token) %>%
       mutate(id = as.integer(id))

## �������� ���������� �� �����������
vk_stat_by_ads <- vkGetAdStatistics(account_id   = 1600134264,
                                    ids_type     = "ad",
                                    ids          = ads$id ,
                                    period       = "day",
                                    date_from    = "2010-01-01",
                                    date_to      = Sys.Date(),
                                    access_token = vkauth$access_token)

# ���������� ������ � ���� �������
vkdata <- left_join(vk_stat_by_ads, ads, by = 'id', suffix = c("", "_ads")) %>%
          left_join(camp, by = c('campaign_id' = 'id'), suffix = c("", "_camp")) 

# �������� NA �� ����
vkdata <- mutate(vkdata, 
                 across(where(~ is.numeric(.x) || is.integer(.x)), replace_na, 0), 
                 day = as.Date(day))

# ############################# #
# ############################# #
# ������ � ��������� ���������  #
# ############################# #
# ############################# #

# �������� �������������� ������ 
vkauth <- readRDS("C:/vkauth/vkauth.rds")

# �������� ��� ��������� ��������
ad_accounts <- vkGetAdAccounts(vkauth$access_token)

# �������� �������� �� ���������� ��������
vkclients   <- vkGetAdClients(account_id = 1900002395, 
                              access_token = vkauth$access_token, 
                              api_version = "5.73")  

# ����������� ������ �� �����������
ag_ads <- vkGetAds(
                account_id   = 1900002395,
                client_id    = 1604857373,
                access_token = vkauth$access_token) %>%
       mutate(id = as.integer(id))

# ����������� ���������� �� �����������
ag_vk_data <- vkGetAdStatistics(account_id   = 1900002395,
                  ids_type     = "ad",
                  ids          = ag_ads$id ,
                  period       = "day",
                  date_from    = "2020-11-01",
                  date_to      = Sys.Date(),
                  access_token = vkauth$access_token)

# ����������� ������ ��������
ag_camps <- vkGetAdCampaigns(account_id   = 1900002395,
                             client_id    = 1604857373,
                             access_token = vkauth$access_token)

# ���������� ������
# ���������� ������ � ���� �������
vkdata <- left_join(ag_vk_data, ag_ads, by = 'id', suffix = c("", "_ads")) %>%
          left_join(ag_camps, by = c('campaign_id' = 'id'), suffix = c("", "_camp")) 

# �������� NA �� ����
vkdata <- mutate(vkdata, 
                 across(where(~ is.numeric(.x) || is.integer(.x)), replace_na, 0), 
                 day = as.Date(day))
