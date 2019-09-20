# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user1 = User.create!(
    name: "hoge1",
    email: "hoge1@hoge.hoge",
    password:               "hogehoge",
    password_confirmation:   "hogehoge"
)
Profile.create!(
    user_id: user1.id,
    location: "nagoya",
    about: "hoge1! hoge1! hoge1!"
)
Post.create!(
    user_id: user1.id,
    content: "hoge1の投稿1"
)

i = 2
locate = [
    "nagoya",
    "Osaka",
    "Tokyo",
    "USA",
    "Los"
]
10.times do
    user = User.create!(
        name: "hoge#{i}",
        email: "hoge#{i}@hoge.hoge",
        password: "hogehoge",
        password_confirmation: "hogehoge"
    )
    Profile.create!(
        user_id: user.id,
        location: locate[i%5]
    )
    Post.create!(
        user_id: user.id,
        content: "hoge#{i}の投稿1"
    )
    Post.create!(
        user_id: user.id,
        content: "hoge#{i}の投稿2"
    )
    i += 1
end