
module birdnft::birdnft {
use std::string::{utf8, String};
use sui::package;
use sui::display;  
public struct BIRDNFT has drop {}

public struct NumCount has key {
    id: UID,
    current_number: u64
}

public struct NFT has key, store {
  id: UID,
  name: String,
  collection: String,
  number: u64
}

fun init(otw: BIRDNFT, ctx: &mut TxContext) {
    let publisher = package::claim(otw, ctx);
    let keys = vector[
            utf8(b"name"),
            utf8(b"image_url"),
            utf8(b"description"),
        ];

        let values = vector[
            utf8(b"{collection} #{number} {name}"),
            utf8(b"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTthlzS2gC2JL_LjqtShVQ3icv73-EAqXVHXw&s"),
            utf8(b"Collection of Black Birds!"),
        ];

        let mut display = display::new_with_fields<NFT>(
            &publisher, keys, values, ctx
        );
        
        display::update_version(&mut display);
        transfer::public_transfer(publisher, tx_context::sender(ctx));
        transfer::public_transfer(display, tx_context::sender(ctx));
        transfer::share_object(NumCount{
            id: object::new(ctx),
            current_number: 0
        });
}


public entry fun mint_nft(name: String, num_count: &mut NumCount, ctx: &mut TxContext) {
    let current_number = &mut num_count.current_number;
    *current_number = *current_number + 1;
    let new_bird_nft = NFT {
        id: object::new(ctx),
        name,
        collection: utf8(b"BlackBirds"),
        number: *current_number
    };
    transfer::public_transfer(new_bird_nft, tx_context::sender(ctx));
}
}

