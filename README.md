## usersテーブル

| column       | type    | options     | 
| :----------: | :-----: | :---------: | 
| name         | string  | null: false | 
| name_reading | string  | null: false | 
| nickname     | string  | null: false | 
| password     | string  | null: false | 
| email        | string  | null: false | 
| birthday     | integer | null: false |

### association

has_many :items
has_many :purchases
has_one :address


## itemsテーブル

| column   | type       | option      | 
| :------: | :--------: | :---------: | 
| text     | text       | null: false | 
| describe | text       | null: false | 
| price    | integer    | null: false | 
| user_id  | references |             | 

### association

- belongs_to :users
- has_one :order

## addressesテーブル

| column        | type       | option      | 
| :-----------: | :--------: | :---------: | 
| post_code     | string     | null: false | 
| prefecture    | integer    | null: false | 
| city          | string     | null: false | 
| house_number  | string     | null: false | 
| building_name | string     |             | 
| phone_number  | integer    | null: false | 
| user_id       | references |             | 
| item_id       | references |             | 

### association

- belongs_to :users
- has_many :order

## ordersテーブル

| column  | type       | option      | 
| :-----: | :--------: | :---------: | 
| price   | integer    | null: false | 
| user_id | references |             | 
| item_id | references |             | 

### association

- belongs_to :users
- belongs_to :items
- belongs_to :addresses

