## usersテーブル

| column             | type    | options                  | 
| :----------------: | :-----: | :----------------------: | 
| first_name         | string  | null: false              | 
| last_name          | string  | null: false              | 
| first_name_kana    | string  | null: false              | 
| last_name_kana     | string  | null: false              | 
| nickname           | string  | null: false              | 
| encrypted_password | string  | null: false              | 
| email              | string  | null: false, unique: true| 
| birthday           | date    | null: false              |

### association

has_many :items
has_many :orders

## itemsテーブル

| column       | type       | option            | 
| :----------: | :--------: | :---------------: | 
| text         | string     | null: false       | 
| describe     | text       | null: false       | 
| category_id  | integer    | null: false       | 
| status_id    | integer    | null: false       | 
| charge_id    | integer    | null: false       | 
| prefecture_id| integer    | null: false       | 
| day_id       | integer    | null: false       | 
| price        | integer    | null: false       | 
| user         | references | foreign_key: true | 

### association

- belongs_to :user
- has_one :order

## addressesテーブル

| column        | type       | option            | 
| :-----------: | :--------: | :---------------: | 
| post_code     | string     | null: false       | 
| prefecture_id | integer    | null: false       | 
| city          | string     | null: false       | 
| house_number  | string     | null: false       | 
| building_name | string     |                   | 
| phone_number  | string     | null: false       | 
| order         | references | foreign_key: true | 

### association

- belongs_to :order

## ordersテーブル

| column  | type       | option            | 
| :-----: | :--------: | :---------------: | 
| user    | references | foreign_key: true | 
| item    | references | foreign_key: true | 

### association

- belongs_to :user
- belongs_to :item
- has_one :address

