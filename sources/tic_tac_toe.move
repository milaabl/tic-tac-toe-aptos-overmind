/* 
    Bring the classic game of Tic Tac Toe onto the blockchain. Get practice using move vectors and 
    aptos coins. 

    Key Concepts: 
        - Aptos coin
        - vector
*/
module overmind::tic_tac_toe {
    //==============================================================================================
    // Dependencies
    //==============================================================================================
    use std::signer;
    use std::vector;
    use aptos_framework::coin;
    use aptos_framework::timestamp;
    use std::option::{Self, Option};
    use aptos_framework::aptos_coin::{AptosCoin};
    use aptos_framework::event::{Self, EventHandle};
    use aptos_framework::account::{Self, SignerCapability};

    #[test_only]
    use aptos_framework::aptos_coin::{Self};

    //==============================================================================================
    // Constants - DO NOT MODIFY
    //==============================================================================================    

    // Seed for the module's resource account    
    const SEED: vector<u8> = b"tic-tac-toe";

    const PRIZE_AMOUNT_APT: u64 = 1000000000; // 10 APT coins

    // Duration for rounds of tic tac toe games
    const DURATION_GAME_START: u64 = 5000;
    const DURATION_ROUND: u64 = 2500;

    // Values for each player in a game
    const PLAYER_ONE: u8 = 0;
    const PLAYER_TWO: u8 = 1;

    // Possible game results
    const GAME_RESULTS_PLAYER_ONE: u8 = 0;
    const GAME_RESULTS_PLAYER_TWO: u8 = 1;
    const GAME_RESULTS_TIE: u8 = 2;
    const GAME_RESULTS_EXPIRED: u8 = 3;


    //==============================================================================================
    // Error codes - DO NOT MODIFY
    //==============================================================================================

    const EInsufficientAptBalance: u64 = 0;
    const EPlayerAddressesAreTheSame: u64 = 1;
    const EInvalidGameId: u64 = 3;
    const EUserNotPlayer: u64 = 4;
    const EGameHasResult: u64 = 5;
    const ENotPlayersTurn: u64 = 6;
    const EInvalidSpaceIndices: u64 = 7;
    const ESpaceAlreadyMarked: u64 = 8;
    const EGameIsNotExpired: u64 = 9;
    const EPrizeAlreadyClaimed: u64 = 10;
    const ETurnIsExpired: u64 = 11;

    //==============================================================================================
    // Module Structs - DO NOT MODIFY
    //==============================================================================================

    /* 
        Holds information to be used in the module
    */
    struct State has key {
        // the signer cap of the module's resource account
        signer_cap: SignerCapability,
        // number of games created
        game_count: u64, 
        // vector of all games - game's index = game's id
		games: vector<Game>,
        // Events
        game_created_events: EventHandle<GameCreatedEvent>,
        game_won_events: EventHandle<GameWonEvent>,
        game_tied_events: EventHandle<GameTiedEvent>,
        game_round_events: EventHandle<GameRoundEvent>,
        game_expired_events: EventHandle<GameExpiredEvent>
    }

    /* 
        Holds information for a specific game
    */
    struct Game has store, drop {
        // id of the game
        game_id: u64, 
        // Address of the game creator
        creator: address, 
		// Address of player one
		player_one: address, 
		// Address of player two
		player_two: address, 
        // whose turn it currently is: PLAYER_ONE, PLAYER_TWO
        current_turn: u8,
		// The timestamp which marks the game as expired
		expiration_timestamp_seconds: u64, 
		// The current spaces of the board - None: empty, 1: player one, 2: player two
        // NOTE: the first index is the row, the second index is the column
		spaces: vector<vector<Option<u8>>>,
		// result of game - 1: player one won, 2: player two won, 3: tie, 4: game canceled, 
        //                  None: Game in progress
		result: Option<u8> 
    }   
    
    //==============================================================================================
    // Event structs - DO NOT MODIFY
    //==============================================================================================

    struct GameCreatedEvent has store, drop {
        // Address of the game creator
        game_creator: address, 
        // Address of the first player
        player_one: address, 
        // Address of the second player
        player_two: address, 
        // id of the game being created
        game_id: u64,
        // timestamp of when the event was emitted
        event_creation_timestamp_seconds: u64
    }

    struct GameWonEvent has store, drop {
        // id of the game that was won
        game_id: u64, 
        // Address of the winner
        winner: address,
        // timestamp of when the event was emitted
        event_creation_timestamp_seconds: u64
    }

    struct GameTiedEvent has store, drop {
        // id of the game that was tied
        game_id: u64,
        // timestamp of when the event was emitted
        event_creation_timestamp_seconds: u64
    }

    struct GameRoundEvent has store, drop {
        // id of the game 
        game_id: u64, 
        // address of the player making a move
        player: address, 
        // row index of the space being marked by the player
        row_index: u8, 
        // column index of the space being marked by the player
        column_index: u8,
        // timestamp of when the event was emitted
        event_creation_timestamp_seconds: u64
    }

    struct GameExpiredEvent has store, drop {
        // id of the game that is being expired
        game_id: u64, 
        // address that is receiving the game's prize
        prize_recipient: address,
        // timestamp of when the event was emitted
        event_creation_timestamp_seconds: u64
    }

    //==============================================================================================
    // Functions
    //==============================================================================================

    /*
		Initializes the module by creating a resource account, and creating a new State resource
		@param admin - Signer representing the admin's account
    */
    fun init_module(admin: &signer) {

        // TODO: Create resource account with admin and the provided SEED const

        // TODO: Register the resource account with the the AptosCoin

        // TODO: Create the State resource and move it to the resource account
        
    }

    /* 
		Creates a new game of trust. Takes in APT from the creator.
		@param game_creator - signer representing the account creating the new game
		@param player_one_address - address of the first player
		@param player_two_address - address of the second player
    */
    public entry fun create_game(
        game_creator: &signer, 
        player_one_address: address, 
        player_two_address: address
    ) acquires State {
        // TODO: Ensure the creator has enough apt
        // 
        // HINT: 
        //      - Use PRIZE_AMOUNT_APT for the amount of apt to check for
        //      - Use the check_if_user_has_enough_apt_coin function

        // TODO: Transfer PRIZE_AMOUNT_APT of apt from the game_creator to the module's resource
        //          account
        //
        // HINT: Make sure to use the PRIZE_AMOUNT_APT constant

        // TODO: Ensure the two player addresses are different
        // 
        // HINT: Use the check_if_players_are_different function

        // TODO: Increment the State's game counter

        // TODO: Create a new Game object and add it to the end of the State's game list
        //
        // HINT: 
        //      - Set current turn to PLAYER_ONE
        //      - Set expiration_timestamp_seconds to the current timestamp plus DURATION_GAME_START
        //      - Set spaces to a 3 by 3 two dimensional vector where each space is an empty 
        //          option<u64>
        //      - Set result to an empty option<u64>

        // TODO: Emit a GameCreatedEvent
        
    }

    /* 
		Marks a space on the game's board. 
		@param player - signer representing the account of the player in a game
		@param game_id - the game id associated with the game the player is submitting a decision in
		@param row_index - the row index of the space to be selected (between 0 and 3, inclusive)
		@param column_index - the col index fo the space to be selected (between 0 and 3, inclusive)
    */ 
    public entry fun mark_space(
        player: &signer, 
        game_id: u64, 
        row_index: u8, 
        column_index: u8
    ) acquires State {
        // TODO: Ensure game_id is a valid id
        // 
        // HINT: Use the check_if_game_id_is_valid function

        // TODO: Ensure `player` is a player in the game
        // 
        // HINT: Use the check_if_user_is_player function

        // TODO: Ensure the game is still active (does not have a result)
        // 
        // HINT: Use the check_if_game_has_no_result function
        
        // TODO: Ensure it is player's turn
        // 
        // HINT: Use the check_if_it_is_players_turn function

        // TODO: Ensure player's turn is not expired
        // 
        // HINT: Use the check_if_turn_is_expired function

        // TODO Ensure the row and column indices are valid
        // 
        // HINT: Use the check_if_space_numbers_are_valid function

        // TODO: Ensure the space is not marked
        // 
        // HINT: Use the check_if_space_is_open function
        // TODO: Fill the specified game space with the correct value (according to consts defined 
        //          above)

        // TODO: Emit the GameRoundEvent

        // TODO: Check if the user has won. If so, do the following: 
        //          - Fill the game's result with the correct results (according to consts defined 
        //              above)
        //          - Transfer `PRIZE_AMOUNT_APT` of apt from the module's resource account to the 
        //              winning player
        //          - Emit the GameWonEvent
        //          - Return
        //
        // HINT: 
        //      - Use the player_has_won function to detect a win


        // TODO: Check if all game spaces are marked. If so, do the following: 
        //          - Fill the game's result with the correct results (according to consts defined 
        //              above)
        //          - Transfer `PRIZE_AMOUNT_APT` of apt from the module's resource account to the 
        //              game creator
        //          - Emit the GameTiedEvent
        //          - Return
        //
        // HINT: 
        //      - Use the game_spaces_are_full function to check if the game spaces are full

        // TODO: Update the game's current turn to the other player

        // TODO: Update the game's expiration timestamp to be now plus DURATION_ROUND
    }

    /*
		Use by anyone to end a game early if either of the player does not complete an action by the 
            designated expiration timestamp. 
		@param game_id - the game id associated with the game that will be ended early
    */  
    public entry fun release_funds_after_expiration(game_id: u64) acquires State {
        // TODO: Ensure game id is valid
        //
        // HINT: Use the check_if_game_id_is_valid function

        // Ensure the game is expired
        // 
        // HINT: Use the check_if_game_is_expired function

        // Ensure the prize is unclaimed
        // 
        // HINT: Use the check_if_prize_is_unclaimed function

        // TODO: Transfer `PRIZE_AMOUNT_APT` amount of apt to the correct player
        // 
        // HINT: Release the prize to the last player to complete a turn

        // TODO: Fill the game's result with the correct result (according to the GAME_RESULTS 
        //          constants defined above)

        // TODO: Emit the GameExpiredEvent

    }

    //==============================================================================================
    // Helper functions
    //==============================================================================================

    /*
		Return the module's resource account 
		@return - the address of the module's resource account
    */  
    inline fun get_resource_account_address(): address {
        // TODO: Fetch and return the module's resource account
        //
        // HINT: USE the `SEED` constant
        
    }

    /*
		Check if the player has won with their new move
        @param spaces - the current spaces of the game
        @param row_index - the row index of the player's new move
        @param column_index - the column index of the player's new move
        @param player - the code specifying which player made the move
		@return - true if the player has won, and false otherwise
    */  
    inline fun player_has_won(
        spaces: &vector<vector<Option<u8>>>, 
        row_index: u8, 
        column_index: u8, 
        player: u8
    ): bool {
        // TODO: Check the row, column, and diagonals to see if the player has won and return the 
        //          result
        //
        // HINT: Use row_is_filled_by_player, col_is_filled_by_player, and 
        //          diagonal_is_filled_by_player to check the spaces
        
    }
    
    /*
		Check if the player has filled a row with their move
        @param spaces - the current spaces of the game
        @param row_index - the row index of the player's new move
        @param player - the code specifying which player made the move
		@return - true if the specified row is filled by the player and false otherwise
    */  
    inline fun row_is_filled_by_player(
        spaces: &vector<vector<Option<u8>>>, 
        row_index: u8, 
        player: u8
    ): bool {
        // TODO: Return true if the spaces of the specified row are all filled by the specified 
        //          player and return false otherwise

    }

    /*
		Check if the player has filled a column with their move
        @param spaces - the current spaces of the game
        @param column_index - the column index of the player's new move
        @param player - the code specifying which player made the move
		@return - true if the specified column is filled by the player and false otherwise
    */  
    inline fun col_is_filled_by_player(
        spaces: &vector<vector<Option<u8>>>, 
        column_index: u8,
        player: u8
    ): bool {
        // TODO: Return true if the spaces of the specified column are all filled by the specified 
        //          player and return false otherwise
    }

    /*
		Check if the player has filled a diagonal with their move
        @param spaces - the current spaces of the game
        @param player - the code specifying which player made the move
		@return - true if the specified column is filled by the player and false otherwise
    */  
    inline fun diagonal_is_filled_by_player(
        spaces: &vector<vector<Option<u8>>>, 
        player: u8
    ): bool {
        // TODO: Check both diagonals on the game board if the player has won
        //
        // HINT: Use left_to_right_diagonal_is_filled_by_player and 
        //          right_to_left_diagonal_is_filled_by_player to check for this

    }

    /*
		Check if the player has filled the left to right diagonal with their move
        @param spaces - the current spaces of the game
        @param player - the code specifying which player made the move
		@return - true if the left to right diagonal is filled by the player and false otherwise
    */  
    inline fun left_to_right_diagonal_is_filled_by_player(
        spaces: &vector<vector<Option<u8>>>, 
        player: u8
    ): bool {
        let is_diagonal_filled = true;

        // TODO: Return true if the spaces of the left to right diagonal are all filled by the 
        //          specified player and return false otherwise

    }

    /*
		Check if the player has filled the right to left diagonal with their move
        @param spaces - the current spaces of the game
        @param player - the code specifying which player made the move
		@return - true if the right to left diagonal is filled by the player and false otherwise
    */  
    inline fun right_to_left_diagonal_is_filled_by_player(
        spaces: &vector<vector<Option<u8>>>, 
        player: u8
    ): bool {
        let is_diagonal_filled = true;

        // TODO: Return true if the spaces of the right to left diagonal are all filled by the 
        //          specified player and return false otherwise
        
    }

    /*
		Check if the game spaces are all filled
        @param spaces - the current spaces of the game
		@return - true if the entire board is filled and false otherwise
    */  
    inline fun game_spaces_are_full(spaces: &vector<vector<Option<u8>>>): bool {
        // TODO: Return true if all of the spaces are filled and false otherwise
        
    }

    //==============================================================================================
    // Validation functions
    //==============================================================================================

    inline fun check_if_user_has_enough_apt_coin(user: address, amount_of_apt: u64) {
        // TODO: Ensure the user has equal or greater balance of apt than `amount_of_apt`. If false,
        //          abort with code: EInsufficientAptBalance
        
    }

    inline fun check_if_players_are_different(player_one: address, player_two: address) {
        // TODO: Ensure the two player addresses are not the same. If they are the same,
        //          abort with code: EPlayerAddressesAreTheSame
        
    }

    inline fun check_if_game_id_is_valid(game_count: u64, game_id: u64) {
        // TODO: Ensure the game_id is less than the game_count. If not, abort with code: 
        //          EInvalidGameId
        
    }

    inline fun check_if_user_is_player(user: &address, game: &Game) {
        // TODO: Ensure the user is a player in the given game. If not, abort with code: 
        //          EUserNotPlayer
        
    }

    inline fun check_if_game_has_no_result(game: &Game) {
        // TODO: Ensure the given game has no result yet. If not, abort with code: EGameHasResult
        
    }

    inline fun check_if_it_is_players_turn(player: &address, game: &Game) {
        // TODO: Ensure it is the player's turn. If not, abort with code: ENotPlayersTurn
        
    }

    inline fun check_if_turn_is_expired(game: &Game) {
        // TODO: Ensure the given timestamp is greater than the current time. If it is, abort with 
        //          code: ETurnIsExpired
        
    }

    inline fun check_if_space_numbers_are_valid(row_index: u8, column_index: u8) {
        // TODO: Ensure the row and column indices are less then 3. If not, abort with code: 
        //          EInvalidSpaceIndices
        
    }

    inline fun check_if_space_is_open(space: &mut Option<u8>) {
        // TODO: Ensure given space is not already marked. If it is, abort with code: 
        //          ESpaceAlreadyMarked
        
    }

    inline fun check_if_game_is_expired(expiration_timestamp_seconds: u64) {
        // TODO: Ensure given timestamp is less than the current time. If it is, abort with code: 
        //          EGameIsNotExpired
        
    }

    inline fun check_if_prize_is_unclaimed(result: &Option<u8>) {
        // TODO: Ensure the result is none. If it is, abort with code: EPrizeAlreadyClaimed
        
    }

    //==============================================================================================
    // Tests - DO NOT MODIFY
    //==============================================================================================

    #[test(admin = @overmind, user = @0xA)]
    fun test_init_module_success(
        admin: &signer
    ) acquires State {
        let admin_address = signer::address_of(admin);
        account::create_account_for_test(admin_address);

        let aptos_framework = account::create_account_for_test(@aptos_framework);
        let (burn_cap, mint_cap) =
            aptos_coin::initialize_for_test(&aptos_framework);

        init_module(admin);

        let expected_resource_account_address = 
            account::create_resource_address(&admin_address, b"tic-tac-toe");
        assert!(account::exists_at(expected_resource_account_address), 0);

        assert!(
            coin::is_account_registered<AptosCoin>(expected_resource_account_address), 
            0
        );

        let state = borrow_global<State>(expected_resource_account_address);
        assert!(
            account::get_signer_capability_address(&state.signer_cap) == 
                expected_resource_account_address, 
            0
        );
        assert!(
            state.game_count == 0, 
            0
        );
        assert!(
            vector::length(&state.games) == 0, 
            0
        );

        coin::destroy_burn_cap(burn_cap);
        coin::destroy_mint_cap(mint_cap);

        assert!(event::counter(&state.game_created_events) == 0, 2);
        assert!(event::counter(&state.game_won_events) == 0, 2);
        assert!(event::counter(&state.game_tied_events) == 0, 2);
        assert!(event::counter(&state.game_round_events) == 0, 2);
        assert!(event::counter(&state.game_expired_events) == 0, 2);
    }

    #[test(admin = @overmind, player_1 = @0xA, player_2 = @0xB)]
    fun test_create_game_success_1(
        admin: &signer, 
        player_1: &signer, 
        player_2: &signer, 
    ) acquires State {
        let admin_address = signer::address_of(admin);
        let player_1_address = signer::address_of(player_1);
        let player_2_address = signer::address_of(player_2);
        account::create_account_for_test(admin_address);
        account::create_account_for_test(player_1_address);
        account::create_account_for_test(player_2_address);


        let aptos_framework = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&aptos_framework);
        let (burn_cap, mint_cap) =
            aptos_coin::initialize_for_test(&aptos_framework);

        coin::register<AptosCoin>(player_1);
        coin::register<AptosCoin>(player_2);
        coin::register<AptosCoin>(admin);

        init_module(admin);

        aptos_coin::mint(&aptos_framework, player_1_address, PRIZE_AMOUNT_APT);
        create_game(player_1, player_1_address, player_2_address);

        let resource_account_address = 
            account::create_resource_address(&admin_address, b"tic-tac-toe");
        let state = borrow_global<State>(resource_account_address);
        assert!(
            state.game_count == 1, 
            0
        );
        assert!(
            vector::length(&state.games) == 1, 
            0
        );

        assert!(
            coin::balance<AptosCoin>(player_1_address) == 0, 
            0
        );
        assert!(
            coin::balance<AptosCoin>(player_2_address) == 0, 
            0
        );
        assert!(
            coin::balance<AptosCoin>(admin_address) == 0, 
            0
        );
        assert!(
            coin::balance<AptosCoin>(resource_account_address) == 1000000000, 
            0
        );

        let game = vector::borrow(&state.games, 0); 
        assert!(
            game.creator == player_1_address,
            0
        );
        assert!(
            game.player_one == player_1_address,
            0
        );
        assert!(
            game.player_two == player_2_address,
            0
        );
        assert!(
            game.current_turn == 0,
            0
        );
        assert!(
            game.expiration_timestamp_seconds == 5000,
            0
        );
        assert!(
            game.spaces == vector[
                vector[option::none(), option::none(), option::none()],
                vector[option::none(), option::none(), option::none()],
                vector[option::none(), option::none(), option::none()]
            ],
            0
        );
        assert!(
            option::is_none(&game.result),
            0
        );

        coin::destroy_burn_cap(burn_cap);
        coin::destroy_mint_cap(mint_cap);

        assert!(event::counter(&state.game_created_events) == 1, 2);
        assert!(event::counter(&state.game_won_events) == 0, 2);
        assert!(event::counter(&state.game_tied_events) == 0, 2);
        assert!(event::counter(&state.game_round_events) == 0, 2);
        assert!(event::counter(&state.game_expired_events) == 0, 2);
    }

    #[test(admin = @overmind, player_1 = @0xA, player_2 = @0xB)]
    fun test_create_game_success_2(
        admin: &signer, 
        player_1: &signer, 
        player_2: &signer, 
    ) acquires State {
        let admin_address = signer::address_of(admin);
        let player_1_address = signer::address_of(player_1);
        let player_2_address = signer::address_of(player_2);
        account::create_account_for_test(admin_address);
        account::create_account_for_test(player_1_address);
        account::create_account_for_test(player_2_address);


        let aptos_framework = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&aptos_framework);
        let (burn_cap, mint_cap) =
            aptos_coin::initialize_for_test(&aptos_framework);

        coin::register<AptosCoin>(player_1);
        coin::register<AptosCoin>(player_2);
        coin::register<AptosCoin>(admin);

        init_module(admin);

        timestamp::fast_forward_seconds(61000);

        aptos_coin::mint(&aptos_framework, player_2_address, PRIZE_AMOUNT_APT);
        create_game(player_2, player_2_address, player_1_address);

        let resource_account_address = 
            account::create_resource_address(&admin_address, b"tic-tac-toe");
        let state = borrow_global<State>(resource_account_address);
        assert!(
            state.game_count == 1, 
            0
        );
        assert!(
            vector::length(&state.games) == 1, 
            0
        );

        assert!(
            coin::balance<AptosCoin>(player_1_address) == 0, 
            0
        );
        assert!(
            coin::balance<AptosCoin>(player_2_address) == 0, 
            0
        );
        assert!(
            coin::balance<AptosCoin>(admin_address) == 0, 
            0
        );
        assert!(
            coin::balance<AptosCoin>(resource_account_address) == 1000000000, 
            0
        );

        let game = vector::borrow(&state.games, 0); 
        assert!(
            game.creator == player_2_address,
            0
        );
        assert!(
            game.player_one == player_2_address,
            0
        );
        assert!(
            game.player_two == player_1_address,
            0
        );
        assert!(
            game.current_turn == 0,
            0
        );
        assert!(
            game.expiration_timestamp_seconds == 61000 + 5000,
            0
        );
        assert!(
            game.spaces == vector[
                vector[option::none(), option::none(), option::none()],
                vector[option::none(), option::none(), option::none()],
                vector[option::none(), option::none(), option::none()]
            ],
            0
        );
        assert!(
            option::is_none(&game.result),
            0
        );

        coin::destroy_burn_cap(burn_cap);
        coin::destroy_mint_cap(mint_cap);

        assert!(event::counter(&state.game_created_events) == 1, 2);
        assert!(event::counter(&state.game_won_events) == 0, 2);
        assert!(event::counter(&state.game_tied_events) == 0, 2);
        assert!(event::counter(&state.game_round_events) == 0, 2);
        assert!(event::counter(&state.game_expired_events) == 0, 2);
    }

    #[test(admin = @overmind, player_1 = @0xA, player_2 = @0xB)]
    fun test_create_game_success_multiple_games(
        admin: &signer, 
        player_1: &signer, 
        player_2: &signer, 
    ) acquires State {
        let admin_address = signer::address_of(admin);
        let player_1_address = signer::address_of(player_1);
        let player_2_address = signer::address_of(player_2);
        account::create_account_for_test(admin_address);
        account::create_account_for_test(player_1_address);
        account::create_account_for_test(player_2_address);


        let aptos_framework = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&aptos_framework);
        let (burn_cap, mint_cap) =
            aptos_coin::initialize_for_test(&aptos_framework);

        coin::register<AptosCoin>(player_1);
        coin::register<AptosCoin>(player_2);
        coin::register<AptosCoin>(admin);

        init_module(admin);

        timestamp::fast_forward_seconds(61000);

        aptos_coin::mint(&aptos_framework, player_2_address, PRIZE_AMOUNT_APT);
        create_game(player_2, player_2_address, player_1_address);

        aptos_coin::mint(&aptos_framework, player_1_address, PRIZE_AMOUNT_APT);
        create_game(player_1, player_2_address, player_1_address);

        aptos_coin::mint(&aptos_framework, player_2_address, PRIZE_AMOUNT_APT);
        create_game(player_2, player_1_address, player_2_address);

        let resource_account_address = 
            account::create_resource_address(&admin_address, b"tic-tac-toe");
        let state = borrow_global<State>(resource_account_address);
        assert!(
            state.game_count == 3, 
            0
        );
        assert!(
            vector::length(&state.games) == 3, 
            0
        );

        assert!(
            coin::balance<AptosCoin>(player_1_address) == 0, 
            0
        );
        assert!(
            coin::balance<AptosCoin>(player_2_address) == 0, 
            0
        );
        assert!(
            coin::balance<AptosCoin>(admin_address) == 0, 
            0
        );
        assert!(
            coin::balance<AptosCoin>(resource_account_address) == 1000000000 * 3, 
            0
        );

        coin::destroy_burn_cap(burn_cap);
        coin::destroy_mint_cap(mint_cap);

        assert!(event::counter(&state.game_created_events) == 3, 2);
        assert!(event::counter(&state.game_won_events) == 0, 2);
        assert!(event::counter(&state.game_tied_events) == 0, 2);
        assert!(event::counter(&state.game_round_events) == 0, 2);
        assert!(event::counter(&state.game_expired_events) == 0, 2);
    }

    #[test(admin = @overmind, player_1 = @0xA, player_2 = @0xB)]
    #[expected_failure(abort_code = EInsufficientAptBalance, location = Self)]
    fun test_create_game_failure_insufficient_apt(
        admin: &signer, 
        player_1: &signer, 
        player_2: &signer, 
    ) acquires State {
        let admin_address = signer::address_of(admin);
        let player_1_address = signer::address_of(player_1);
        let player_2_address = signer::address_of(player_2);
        account::create_account_for_test(admin_address);
        account::create_account_for_test(player_1_address);
        account::create_account_for_test(player_2_address);


        let aptos_framework = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&aptos_framework);
        let (burn_cap, mint_cap) =
            aptos_coin::initialize_for_test(&aptos_framework);

        coin::register<AptosCoin>(player_1);
        coin::register<AptosCoin>(player_2);

        init_module(admin);

        create_game(player_1, player_1_address, player_2_address);

        let resource_account_address = 
            account::create_resource_address(&admin_address, b"tic-tac-toe");
        let state = borrow_global<State>(resource_account_address);
        assert!(
            state.game_count == 1, 
            0
        );
        assert!(
            vector::length(&state.games) == 1, 
            0
        );

        let game = vector::borrow(&state.games, 0); 
        assert!(
            game.creator == player_1_address,
            0
        );
        assert!(
            game.player_one == player_1_address,
            0
        );
        assert!(
            game.player_two == player_2_address,
            0
        );
        assert!(
            game.current_turn == 0,
            0
        );
        assert!(
            game.expiration_timestamp_seconds == 5000,
            0
        );
        assert!(
            game.spaces == vector[
                vector[option::none(), option::none(), option::none()],
                vector[option::none(), option::none(), option::none()],
                vector[option::none(), option::none(), option::none()]
            ],
            0
        );
        assert!(
            option::is_none(&game.result),
            0
        );

        coin::destroy_burn_cap(burn_cap);
        coin::destroy_mint_cap(mint_cap);

        assert!(event::counter(&state.game_created_events) == 1, 2);
        assert!(event::counter(&state.game_won_events) == 0, 2);
        assert!(event::counter(&state.game_tied_events) == 0, 2);
        assert!(event::counter(&state.game_round_events) == 0, 2);
        assert!(event::counter(&state.game_expired_events) == 0, 2);
    }

    #[test(admin = @overmind, player_1 = @0xA, player_2 = @0xB)]
    #[expected_failure(abort_code = EPlayerAddressesAreTheSame, location = Self)]
    fun test_create_game_failure_players_match(
        admin: &signer, 
        player_1: &signer, 
        player_2: &signer, 
    ) acquires State {
        let admin_address = signer::address_of(admin);
        let player_1_address = signer::address_of(player_1);
        let player_2_address = signer::address_of(player_2);
        account::create_account_for_test(admin_address);
        account::create_account_for_test(player_1_address);
        account::create_account_for_test(player_2_address);


        let aptos_framework = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&aptos_framework);
        let (burn_cap, mint_cap) =
            aptos_coin::initialize_for_test(&aptos_framework);

        coin::register<AptosCoin>(player_1);
        coin::register<AptosCoin>(player_2);

        init_module(admin);

        aptos_coin::mint(&aptos_framework, player_1_address, PRIZE_AMOUNT_APT);
        create_game(player_1, player_1_address, player_1_address);

        let resource_account_address = 
            account::create_resource_address(&admin_address, b"tic-tac-toe");
        let state = borrow_global<State>(resource_account_address);
        assert!(
            state.game_count == 1, 
            0
        );
        assert!(
            vector::length(&state.games) == 1, 
            0
        );

        let game = vector::borrow(&state.games, 0); 
        assert!(
            game.creator == player_1_address,
            0
        );
        assert!(
            game.player_one == player_1_address,
            0
        );
        assert!(
            game.player_two == player_2_address,
            0
        );
        assert!(
            game.current_turn == 0,
            0
        );
        assert!(
            game.expiration_timestamp_seconds == 5000,
            0
        );
        assert!(
            game.spaces == vector[
                vector[option::none(), option::none(), option::none()],
                vector[option::none(), option::none(), option::none()],
                vector[option::none(), option::none(), option::none()]
            ],
            0
        );
        assert!(
            option::is_none(&game.result),
            0
        );

        coin::destroy_burn_cap(burn_cap);
        coin::destroy_mint_cap(mint_cap);

        assert!(event::counter(&state.game_created_events) == 1, 2);
        assert!(event::counter(&state.game_won_events) == 0, 2);
        assert!(event::counter(&state.game_tied_events) == 0, 2);
        assert!(event::counter(&state.game_round_events) == 0, 2);
        assert!(event::counter(&state.game_expired_events) == 0, 2);
    }

    #[test(admin = @overmind, player_1 = @0xA, player_2 = @0xB)]
    fun test_mark_space_success_1(
        admin: &signer, 
        player_1: &signer, 
        player_2: &signer, 
    ) acquires State {
        let admin_address = signer::address_of(admin);
        let player_1_address = signer::address_of(player_1);
        let player_2_address = signer::address_of(player_2);
        account::create_account_for_test(admin_address);
        account::create_account_for_test(player_1_address);
        account::create_account_for_test(player_2_address);


        let aptos_framework = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&aptos_framework);
        let (burn_cap, mint_cap) =
            aptos_coin::initialize_for_test(&aptos_framework);

        coin::register<AptosCoin>(player_1);
        coin::register<AptosCoin>(player_2);
        coin::register<AptosCoin>(admin);

        init_module(admin);

        timestamp::fast_forward_seconds(61000);

        aptos_coin::mint(&aptos_framework, player_1_address, PRIZE_AMOUNT_APT);
        create_game(player_1, player_1_address, player_2_address);

        timestamp::fast_forward_seconds(3230);

        mark_space(player_1, 0, 1, 1);

        let resource_account_address = 
            account::create_resource_address(&admin_address, b"tic-tac-toe");
        let state = borrow_global<State>(resource_account_address);
        assert!(
            state.game_count == 1, 
            0
        );
        assert!(
            vector::length(&state.games) == 1, 
            0
        );

        let game = vector::borrow(&state.games, 0); 
        assert!(
            game.creator == player_1_address, 
            0
        );
        assert!(
            game.player_one == player_1_address,
            0
        );
        assert!(
            game.player_two == player_2_address,
            0
        );
        assert!(
            game.current_turn == 1,
            0
        );
        assert!(
            game.expiration_timestamp_seconds == 61000 + 3230 + 2500,
            0
        );
        assert!(
            game.spaces == vector[
                vector[option::none(), option::none(), option::none()],
                vector[option::none(), option::some(0), option::none()],
                vector[option::none(), option::none(), option::none()]
            ],
            0
        );
        assert!(
            option::is_none(&game.result),
            0
        );

        assert!(
            coin::balance<AptosCoin>(player_1_address) == 0, 
            0
        );
        assert!(
            coin::balance<AptosCoin>(player_2_address) == 0, 
            0
        );
        assert!(
            coin::balance<AptosCoin>(admin_address) == 0, 
            0
        );
        assert!(
            coin::balance<AptosCoin>(resource_account_address) == 1000000000, 
            0
        );


        let resource_account_address = 
            account::create_resource_address(&admin_address, b"tic-tac-toe");
        let state = borrow_global<State>(resource_account_address);

        coin::destroy_burn_cap(burn_cap);
        coin::destroy_mint_cap(mint_cap);

        assert!(event::counter(&state.game_created_events) == 1, 2);
        assert!(event::counter(&state.game_won_events) == 0, 2);
        assert!(event::counter(&state.game_tied_events) == 0, 2);
        assert!(event::counter(&state.game_round_events) == 1, 2);
        assert!(event::counter(&state.game_expired_events) == 0, 2);
    }

    #[test(admin = @overmind, player_1 = @0xA, player_2 = @0xB)]
    fun test_mark_space_success_2(
        admin: &signer, 
        player_1: &signer, 
        player_2: &signer, 
    ) acquires State {
        let admin_address = signer::address_of(admin);
        let player_1_address = signer::address_of(player_1);
        let player_2_address = signer::address_of(player_2);
        account::create_account_for_test(admin_address);
        account::create_account_for_test(player_1_address);
        account::create_account_for_test(player_2_address);


        let aptos_framework = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&aptos_framework);
        let (burn_cap, mint_cap) =
            aptos_coin::initialize_for_test(&aptos_framework);

        coin::register<AptosCoin>(player_1);
        coin::register<AptosCoin>(player_2);
        coin::register<AptosCoin>(admin);

        init_module(admin);

        timestamp::fast_forward_seconds(61000);

        aptos_coin::mint(&aptos_framework, player_1_address, PRIZE_AMOUNT_APT);
        create_game(player_1, player_1_address, player_2_address);

        timestamp::fast_forward_seconds(3230);

        mark_space(player_1, 0, 1, 1);
        mark_space(player_2, 0, 0, 1);
        timestamp::fast_forward_seconds(1000);
        mark_space(player_1, 0, 2, 2);


        let resource_account_address = 
            account::create_resource_address(&admin_address, b"tic-tac-toe");
        let state = borrow_global<State>(resource_account_address);
        assert!(
            state.game_count == 1, 
            0
        );
        assert!(
            vector::length(&state.games) == 1, 
            0
        );

        let game = vector::borrow(&state.games, 0); 
        assert!(
            game.creator == player_1_address, 
            0
        );
        assert!(
            game.player_one == player_1_address,
            0
        );
        assert!(
            game.player_two == player_2_address,
            0
        );
        assert!(
            game.current_turn == 1,
            0
        );
        assert!(
            game.expiration_timestamp_seconds == 61000 + 3230 + 1000 + 2500,
            0
        );
        assert!(
            game.spaces == vector[
                vector[option::none(), option::some(1), option::none()],
                vector[option::none(), option::some(0), option::none()],
                vector[option::none(), option::none(), option::some(0)]
            ],
            0
        );
        assert!(
            option::is_none(&game.result),
            0
        );

        assert!(
            coin::balance<AptosCoin>(player_1_address) == 0, 
            0
        );
        assert!(
            coin::balance<AptosCoin>(player_2_address) == 0, 
            0
        );
        assert!(
            coin::balance<AptosCoin>(admin_address) == 0, 
            0
        );
        assert!(
            coin::balance<AptosCoin>(resource_account_address) == 1000000000, 
            0
        );


        let resource_account_address = 
            account::create_resource_address(&admin_address, b"tic-tac-toe");
        let state = borrow_global<State>(resource_account_address);

        coin::destroy_burn_cap(burn_cap);
        coin::destroy_mint_cap(mint_cap);

        assert!(event::counter(&state.game_created_events) == 1, 2);
        assert!(event::counter(&state.game_won_events) == 0, 2);
        assert!(event::counter(&state.game_tied_events) == 0, 2);
        assert!(event::counter(&state.game_round_events) == 3, 2);
        assert!(event::counter(&state.game_expired_events) == 0, 2);
    }

    #[test(admin = @overmind, player_1 = @0xA, player_2 = @0xB)]
    fun test_mark_space_success_player_one_won(
        admin: &signer, 
        player_1: &signer, 
        player_2: &signer, 
    ) acquires State {
        let admin_address = signer::address_of(admin);
        let player_1_address = signer::address_of(player_1);
        let player_2_address = signer::address_of(player_2);
        account::create_account_for_test(admin_address);
        account::create_account_for_test(player_1_address);
        account::create_account_for_test(player_2_address);


        let aptos_framework = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&aptos_framework);
        let (burn_cap, mint_cap) =
            aptos_coin::initialize_for_test(&aptos_framework);

        coin::register<AptosCoin>(player_1);
        coin::register<AptosCoin>(player_2);
        coin::register<AptosCoin>(admin);

        init_module(admin);

        timestamp::fast_forward_seconds(61000);

        aptos_coin::mint(&aptos_framework, player_1_address, PRIZE_AMOUNT_APT);
        create_game(player_1, player_1_address, player_2_address);

        timestamp::fast_forward_seconds(3230);

        mark_space(player_1, 0, 1, 1);
        mark_space(player_2, 0, 0, 1);
        timestamp::fast_forward_seconds(1000);
        mark_space(player_1, 0, 2, 2);
        mark_space(player_2, 0, 0, 2);
        mark_space(player_1, 0, 0, 0);


        let resource_account_address = 
            account::create_resource_address(&admin_address, b"tic-tac-toe");
        let state = borrow_global<State>(resource_account_address);
        assert!(
            state.game_count == 1, 
            0
        );
        assert!(
            vector::length(&state.games) == 1, 
            0
        );

        let game = vector::borrow(&state.games, 0); 
        assert!(
            game.creator == player_1_address, 
            0
        );
        assert!(
            game.player_one == player_1_address,
            0
        );
        assert!(
            game.player_two == player_2_address,
            0
        );
        assert!(
            game.current_turn == 0,
            0
        );
        assert!(
            game.expiration_timestamp_seconds == 61000 + 3230 + 1000 + 2500,
            0
        );
        assert!(
            game.spaces == vector[
                vector[option::some(0), option::some(1), option::some(1)],
                vector[option::none(), option::some(0), option::none()],
                vector[option::none(), option::none(), option::some(0)]
            ],
            0
        );
        assert!(
            option::contains(&game.result, &0) == true,
            0
        );

        assert!(
            coin::balance<AptosCoin>(player_1_address) == 1000000000, 
            0
        );
        assert!(
            coin::balance<AptosCoin>(player_2_address) == 0, 
            0
        );
        assert!(
            coin::balance<AptosCoin>(admin_address) == 0, 
            0
        );
        assert!(
            coin::balance<AptosCoin>(resource_account_address) == 0, 
            0
        );


        let resource_account_address = 
            account::create_resource_address(&admin_address, b"tic-tac-toe");
        let state = borrow_global<State>(resource_account_address);

        coin::destroy_burn_cap(burn_cap);
        coin::destroy_mint_cap(mint_cap);

        assert!(event::counter(&state.game_created_events) == 1, 2);
        assert!(event::counter(&state.game_won_events) == 1, 2);
        assert!(event::counter(&state.game_tied_events) == 0, 2);
        assert!(event::counter(&state.game_round_events) == 5, 2);
        assert!(event::counter(&state.game_expired_events) == 0, 2);
    }

    #[test(admin = @overmind, player_1 = @0xA, player_2 = @0xB)]
    fun test_mark_space_success_player_two_won(
        admin: &signer, 
        player_1: &signer, 
        player_2: &signer, 
    ) acquires State {
        let admin_address = signer::address_of(admin);
        let player_1_address = signer::address_of(player_1);
        let player_2_address = signer::address_of(player_2);
        account::create_account_for_test(admin_address);
        account::create_account_for_test(player_1_address);
        account::create_account_for_test(player_2_address);


        let aptos_framework = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&aptos_framework);
        let (burn_cap, mint_cap) =
            aptos_coin::initialize_for_test(&aptos_framework);

        coin::register<AptosCoin>(player_1);
        coin::register<AptosCoin>(player_2);
        coin::register<AptosCoin>(admin);

        init_module(admin);

        timestamp::fast_forward_seconds(61000);

        aptos_coin::mint(&aptos_framework, player_1_address, PRIZE_AMOUNT_APT);
        create_game(player_1, player_1_address, player_2_address);

        timestamp::fast_forward_seconds(3230);

        mark_space(player_1, 0, 1, 1);
        mark_space(player_2, 0, 0, 1);
        timestamp::fast_forward_seconds(1000);
        mark_space(player_1, 0, 2, 2);
        mark_space(player_2, 0, 0, 2);
        mark_space(player_1, 0, 1, 0);
        mark_space(player_2, 0, 0, 0);


        let resource_account_address = 
            account::create_resource_address(&admin_address, b"tic-tac-toe");
        let state = borrow_global<State>(resource_account_address);
        assert!(
            state.game_count == 1, 
            0
        );
        assert!(
            vector::length(&state.games) == 1, 
            0
        );

        let game = vector::borrow(&state.games, 0); 
        assert!(
            game.creator == player_1_address, 
            0
        );
        assert!(
            game.player_one == player_1_address,
            0
        );
        assert!(
            game.player_two == player_2_address,
            0
        );
        assert!(
            game.current_turn == 1,
            0
        );
        assert!(
            game.expiration_timestamp_seconds == 61000 + 3230 + 1000 + 2500,
            0
        );
        assert!(
            game.spaces == vector[
                vector[option::some(1), option::some(1), option::some(1)],
                vector[option::some(0), option::some(0), option::none()],
                vector[option::none(), option::none(), option::some(0)]
            ],
            0
        );
        assert!(
            option::contains(&game.result, &1) == true,
            0
        );

        assert!(
            coin::balance<AptosCoin>(player_1_address) == 0, 
            0
        );
        assert!(
            coin::balance<AptosCoin>(player_2_address) == 1000000000, 
            0
        );
        assert!(
            coin::balance<AptosCoin>(admin_address) == 0, 
            0
        );
        assert!(
            coin::balance<AptosCoin>(resource_account_address) == 0, 
            0
        );


        let resource_account_address = 
            account::create_resource_address(&admin_address, b"tic-tac-toe");
        let state = borrow_global<State>(resource_account_address);

        coin::destroy_burn_cap(burn_cap);
        coin::destroy_mint_cap(mint_cap);

        assert!(event::counter(&state.game_created_events) == 1, 2);
        assert!(event::counter(&state.game_won_events) == 1, 2);
        assert!(event::counter(&state.game_tied_events) == 0, 2);
        assert!(event::counter(&state.game_round_events) == 6, 2);
        assert!(event::counter(&state.game_expired_events) == 0, 2);
    }

    #[test(admin = @overmind, player_1 = @0xA, player_2 = @0xB)]
    fun test_mark_space_success_tie(
        admin: &signer, 
        player_1: &signer, 
        player_2: &signer, 
    ) acquires State {
        let admin_address = signer::address_of(admin);
        let player_1_address = signer::address_of(player_1);
        let player_2_address = signer::address_of(player_2);
        account::create_account_for_test(admin_address);
        account::create_account_for_test(player_1_address);
        account::create_account_for_test(player_2_address);


        let aptos_framework = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&aptos_framework);
        let (burn_cap, mint_cap) =
            aptos_coin::initialize_for_test(&aptos_framework);

        coin::register<AptosCoin>(player_1);
        coin::register<AptosCoin>(player_2);
        coin::register<AptosCoin>(admin);

        init_module(admin);

        timestamp::fast_forward_seconds(61000);

        aptos_coin::mint(&aptos_framework, admin_address, PRIZE_AMOUNT_APT);
        create_game(admin, player_1_address, player_2_address);

        timestamp::fast_forward_seconds(3230);

        mark_space(player_1, 0, 0, 0);
        mark_space(player_2, 0, 0, 1);
        timestamp::fast_forward_seconds(1000);
        mark_space(player_1, 0, 1, 1);
        mark_space(player_2, 0, 0, 2);
        mark_space(player_1, 0, 1, 2);
        mark_space(player_2, 0, 1, 0);
        mark_space(player_1, 0, 2, 0);
        mark_space(player_2, 0, 2, 2);
        mark_space(player_1, 0, 2, 1);


        let resource_account_address = 
            account::create_resource_address(&admin_address, b"tic-tac-toe");
        let state = borrow_global<State>(resource_account_address);
        assert!(
            state.game_count == 1, 
            0
        );
        assert!(
            vector::length(&state.games) == 1, 
            0
        );

        let game = vector::borrow(&state.games, 0); 
        assert!(
            game.creator == admin_address, 
            0
        );
        assert!(
            game.player_one == player_1_address,
            0
        );
        assert!(
            game.player_two == player_2_address,
            0
        );
        assert!(
            game.current_turn == 0,
            0
        );
        assert!(
            game.expiration_timestamp_seconds == 61000 + 3230 + 1000 + 2500,
            0
        );
        assert!(
            game.spaces == vector[
                vector[option::some(0), option::some(1), option::some(1)],
                vector[option::some(1), option::some(0), option::some(0)],
                vector[option::some(0), option::some(0), option::some(1)]
            ],
            0
        );
        assert!(
            option::contains(&game.result, &2) == true,
            0
        );

        assert!(
            coin::balance<AptosCoin>(player_1_address) == 0, 
            0
        );
        assert!(
            coin::balance<AptosCoin>(player_2_address) == 0, 
            0
        );
        assert!(
            coin::balance<AptosCoin>(admin_address) == PRIZE_AMOUNT_APT, 
            0
        );


        let resource_account_address = 
            account::create_resource_address(&admin_address, b"tic-tac-toe");
        let state = borrow_global<State>(resource_account_address);

        coin::destroy_burn_cap(burn_cap);
        coin::destroy_mint_cap(mint_cap);

        assert!(event::counter(&state.game_created_events) == 1, 2);
        assert!(event::counter(&state.game_won_events) == 0, 2);
        assert!(event::counter(&state.game_tied_events) == 1, 2);
        assert!(event::counter(&state.game_round_events) == 9, 2);
        assert!(event::counter(&state.game_expired_events) == 0, 2);
    }

    #[test(admin = @overmind, player_1 = @0xA, player_2 = @0xB)]
    #[expected_failure(abort_code = EInvalidGameId, location = Self)]
    fun test_mark_space_failure_invalid_game_id(
        admin: &signer, 
        player_1: &signer, 
        player_2: &signer, 
    ) acquires State {
        let admin_address = signer::address_of(admin);
        let player_1_address = signer::address_of(player_1);
        let player_2_address = signer::address_of(player_2);
        account::create_account_for_test(admin_address);
        account::create_account_for_test(player_1_address);
        account::create_account_for_test(player_2_address);


        let aptos_framework = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&aptos_framework);
        let (burn_cap, mint_cap) =
            aptos_coin::initialize_for_test(&aptos_framework);

        coin::register<AptosCoin>(player_1);
        coin::register<AptosCoin>(player_2);

        init_module(admin);

        timestamp::fast_forward_seconds(61000);

        aptos_coin::mint(&aptos_framework, player_1_address, PRIZE_AMOUNT_APT);
        create_game(player_1, player_1_address, player_2_address);

        timestamp::fast_forward_seconds(3230);

        mark_space(player_1, 1, 1, 1);

        let resource_account_address = 
            account::create_resource_address(&admin_address, b"tic-tac-toe");
        let state = borrow_global<State>(resource_account_address);
        assert!(
            state.game_count == 1, 
            0
        );
        assert!(
            vector::length(&state.games) == 1, 
            0
        );

        let game = vector::borrow(&state.games, 0); 
        assert!(
            game.creator == player_1_address, 
            0
        );
        assert!(
            game.player_one == player_1_address,
            0
        );
        assert!(
            game.player_two == player_2_address,
            0
        );
        assert!(
            game.current_turn == 1,
            0
        );
        assert!(
            game.expiration_timestamp_seconds == 61000 + 3230 + 2500,
            0
        );
        assert!(
            game.spaces == vector[
                vector[option::none(), option::none(), option::none()],
                vector[option::none(), option::some(0), option::none()],
                vector[option::none(), option::none(), option::none()]
            ],
            0
        );
        assert!(
            option::is_none(&game.result),
            0
        );


        let resource_account_address = 
            account::create_resource_address(&admin_address, b"tic-tac-toe");
        let state = borrow_global<State>(resource_account_address);

        coin::destroy_burn_cap(burn_cap);
        coin::destroy_mint_cap(mint_cap);

        assert!(event::counter(&state.game_created_events) == 1, 2);
        assert!(event::counter(&state.game_won_events) == 0, 2);
        assert!(event::counter(&state.game_tied_events) == 0, 2);
        assert!(event::counter(&state.game_round_events) == 1, 2);
        assert!(event::counter(&state.game_expired_events) == 0, 2);
    }

    #[test(admin = @overmind, player_1 = @0xA, player_2 = @0xB)]
    #[expected_failure(abort_code = EUserNotPlayer, location = Self)]
    fun test_mark_space_failure_player_not_in_game(
        admin: &signer, 
        player_1: &signer, 
        player_2: &signer, 
    ) acquires State {
        let admin_address = signer::address_of(admin);
        let player_1_address = signer::address_of(player_1);
        let player_2_address = signer::address_of(player_2);
        account::create_account_for_test(admin_address);
        account::create_account_for_test(player_1_address);
        account::create_account_for_test(player_2_address);


        let aptos_framework = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&aptos_framework);
        let (burn_cap, mint_cap) =
            aptos_coin::initialize_for_test(&aptos_framework);

        coin::register<AptosCoin>(player_1);
        coin::register<AptosCoin>(player_2);

        init_module(admin);

        timestamp::fast_forward_seconds(61000);

        aptos_coin::mint(&aptos_framework, player_1_address, PRIZE_AMOUNT_APT);
        create_game(player_1, player_1_address, player_2_address);

        timestamp::fast_forward_seconds(3230);

        mark_space(admin, 0, 1, 1);

        let resource_account_address = 
            account::create_resource_address(&admin_address, b"tic-tac-toe");
        let state = borrow_global<State>(resource_account_address);
        assert!(
            state.game_count == 1, 
            0
        );
        assert!(
            vector::length(&state.games) == 1, 
            0
        );

        let game = vector::borrow(&state.games, 0); 
        assert!(
            game.creator == player_1_address, 
            0
        );
        assert!(
            game.player_one == player_1_address,
            0
        );
        assert!(
            game.player_two == player_2_address,
            0
        );
        assert!(
            game.current_turn == 1,
            0
        );
        assert!(
            game.expiration_timestamp_seconds == 61000 + 3230 + 2500,
            0
        );
        assert!(
            game.spaces == vector[
                vector[option::none(), option::none(), option::none()],
                vector[option::none(), option::some(0), option::none()],
                vector[option::none(), option::none(), option::none()]
            ],
            0
        );
        assert!(
            option::is_none(&game.result),
            0
        );


        let resource_account_address = 
            account::create_resource_address(&admin_address, b"tic-tac-toe");
        let state = borrow_global<State>(resource_account_address);

        coin::destroy_burn_cap(burn_cap);
        coin::destroy_mint_cap(mint_cap);

        assert!(event::counter(&state.game_created_events) == 1, 2);
        assert!(event::counter(&state.game_won_events) == 0, 2);
        assert!(event::counter(&state.game_tied_events) == 0, 2);
        assert!(event::counter(&state.game_round_events) == 1, 2);
        assert!(event::counter(&state.game_expired_events) == 0, 2);
    }

    #[test(admin = @overmind, player_1 = @0xA, player_2 = @0xB)]
    #[expected_failure(abort_code = EGameHasResult, location = Self)]
    fun test_mark_space_failure_game_is_not_active(
        admin: &signer, 
        player_1: &signer, 
        player_2: &signer, 
    ) acquires State {
        let admin_address = signer::address_of(admin);
        let player_1_address = signer::address_of(player_1);
        let player_2_address = signer::address_of(player_2);
        account::create_account_for_test(admin_address);
        account::create_account_for_test(player_1_address);
        account::create_account_for_test(player_2_address);


        let aptos_framework = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&aptos_framework);
        let (burn_cap, mint_cap) =
            aptos_coin::initialize_for_test(&aptos_framework);

        coin::register<AptosCoin>(player_1);
        coin::register<AptosCoin>(player_2);

        init_module(admin);

        timestamp::fast_forward_seconds(61000);

        aptos_coin::mint(&aptos_framework, player_1_address, PRIZE_AMOUNT_APT);
        create_game(player_1, player_1_address, player_2_address);

        timestamp::fast_forward_seconds(3230);

        mark_space(player_1, 0, 1, 1);
        mark_space(player_2, 0, 0, 0);
        mark_space(player_1, 0, 0, 1);
        mark_space(player_2, 0, 1, 0);
        mark_space(player_1, 0, 2, 1);
        mark_space(player_2, 0, 2, 0);

        let resource_account_address = 
            account::create_resource_address(&admin_address, b"tic-tac-toe");
        let state = borrow_global<State>(resource_account_address);
        assert!(
            state.game_count == 1, 
            0
        );
        assert!(
            vector::length(&state.games) == 1, 
            0
        );

        let game = vector::borrow(&state.games, 0); 
        assert!(
            game.creator == player_1_address, 
            0
        );
        assert!(
            game.player_one == player_1_address,
            0
        );
        assert!(
            game.player_two == player_2_address,
            0
        );
        assert!(
            game.current_turn == 1,
            0
        );
        assert!(
            game.expiration_timestamp_seconds == 61000 + 3230 + 2500,
            0
        );
        assert!(
            game.spaces == vector[
                vector[option::none(), option::none(), option::none()],
                vector[option::none(), option::some(0), option::none()],
                vector[option::none(), option::none(), option::none()]
            ],
            0
        );
        assert!(
            option::is_none(&game.result),
            0
        );


        let resource_account_address = 
            account::create_resource_address(&admin_address, b"tic-tac-toe");
        let state = borrow_global<State>(resource_account_address);

        coin::destroy_burn_cap(burn_cap);
        coin::destroy_mint_cap(mint_cap);

        assert!(event::counter(&state.game_created_events) == 1, 2);
        assert!(event::counter(&state.game_won_events) == 0, 2);
        assert!(event::counter(&state.game_tied_events) == 0, 2);
        assert!(event::counter(&state.game_round_events) == 1, 2);
        assert!(event::counter(&state.game_expired_events) == 0, 2);
    }

    #[test(admin = @overmind, player_1 = @0xA, player_2 = @0xB)]
    #[expected_failure(abort_code = ESpaceAlreadyMarked, location = Self)]
    fun test_mark_space_failure_space_already_marked_by_same_player(
        admin: &signer, 
        player_1: &signer, 
        player_2: &signer, 
    ) acquires State {
        let admin_address = signer::address_of(admin);
        let player_1_address = signer::address_of(player_1);
        let player_2_address = signer::address_of(player_2);
        account::create_account_for_test(admin_address);
        account::create_account_for_test(player_1_address);
        account::create_account_for_test(player_2_address);


        let aptos_framework = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&aptos_framework);
        let (burn_cap, mint_cap) =
            aptos_coin::initialize_for_test(&aptos_framework);

        coin::register<AptosCoin>(player_1);
        coin::register<AptosCoin>(player_2);

        init_module(admin);

        timestamp::fast_forward_seconds(61000);

        aptos_coin::mint(&aptos_framework, player_1_address, PRIZE_AMOUNT_APT);
        create_game(player_1, player_1_address, player_2_address);

        timestamp::fast_forward_seconds(3230);

        mark_space(player_1, 0, 1, 1);
        mark_space(player_2, 0, 0, 0);
        mark_space(player_1, 0, 1, 1);

        let resource_account_address = 
            account::create_resource_address(&admin_address, b"tic-tac-toe");
        let state = borrow_global<State>(resource_account_address);
        assert!(
            state.game_count == 1, 
            0
        );
        assert!(
            vector::length(&state.games) == 1, 
            0
        );

        let game = vector::borrow(&state.games, 0); 
        assert!(
            game.creator == player_1_address, 
            0
        );
        assert!(
            game.player_one == player_1_address,
            0
        );
        assert!(
            game.player_two == player_2_address,
            0
        );
        assert!(
            game.current_turn == 1,
            0
        );
        assert!(
            game.expiration_timestamp_seconds == 61000 + 3230 + 2500,
            0
        );
        assert!(
            game.spaces == vector[
                vector[option::none(), option::none(), option::none()],
                vector[option::none(), option::some(0), option::none()],
                vector[option::none(), option::none(), option::none()]
            ],
            0
        );
        assert!(
            option::is_none(&game.result),
            0
        );


        let resource_account_address = 
            account::create_resource_address(&admin_address, b"tic-tac-toe");
        let state = borrow_global<State>(resource_account_address);

        coin::destroy_burn_cap(burn_cap);
        coin::destroy_mint_cap(mint_cap);

        assert!(event::counter(&state.game_created_events) == 1, 2);
        assert!(event::counter(&state.game_won_events) == 0, 2);
        assert!(event::counter(&state.game_tied_events) == 0, 2);
        assert!(event::counter(&state.game_round_events) == 1, 2);
        assert!(event::counter(&state.game_expired_events) == 0, 2);
    }

    #[test(admin = @overmind, player_1 = @0xA, player_2 = @0xB)]
    #[expected_failure(abort_code = ESpaceAlreadyMarked, location = Self)]
    fun test_mark_space_failure_space_already_marked_by_other_player(
        admin: &signer, 
        player_1: &signer, 
        player_2: &signer, 
    ) acquires State {
        let admin_address = signer::address_of(admin);
        let player_1_address = signer::address_of(player_1);
        let player_2_address = signer::address_of(player_2);
        account::create_account_for_test(admin_address);
        account::create_account_for_test(player_1_address);
        account::create_account_for_test(player_2_address);


        let aptos_framework = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&aptos_framework);
        let (burn_cap, mint_cap) =
            aptos_coin::initialize_for_test(&aptos_framework);

        coin::register<AptosCoin>(player_1);
        coin::register<AptosCoin>(player_2);

        init_module(admin);

        timestamp::fast_forward_seconds(61000);

        aptos_coin::mint(&aptos_framework, player_1_address, PRIZE_AMOUNT_APT);
        create_game(player_1, player_1_address, player_2_address);

        timestamp::fast_forward_seconds(3230);

        mark_space(player_1, 0, 1, 1);
        mark_space(player_2, 0, 1, 1);

        let resource_account_address = 
            account::create_resource_address(&admin_address, b"tic-tac-toe");
        let state = borrow_global<State>(resource_account_address);
        assert!(
            state.game_count == 1, 
            0
        );
        assert!(
            vector::length(&state.games) == 1, 
            0
        );

        let game = vector::borrow(&state.games, 0); 
        assert!(
            game.creator == player_1_address, 
            0
        );
        assert!(
            game.player_one == player_1_address,
            0
        );
        assert!(
            game.player_two == player_2_address,
            0
        );
        assert!(
            game.current_turn == 1,
            0
        );
        assert!(
            game.expiration_timestamp_seconds == 61000 + 3230 + 2500,
            0
        );
        assert!(
            game.spaces == vector[
                vector[option::none(), option::none(), option::none()],
                vector[option::none(), option::some(0), option::none()],
                vector[option::none(), option::none(), option::none()]
            ],
            0
        );
        assert!(
            option::is_none(&game.result),
            0
        );


        let resource_account_address = 
            account::create_resource_address(&admin_address, b"tic-tac-toe");
        let state = borrow_global<State>(resource_account_address);

        coin::destroy_burn_cap(burn_cap);
        coin::destroy_mint_cap(mint_cap);

        assert!(event::counter(&state.game_created_events) == 1, 2);
        assert!(event::counter(&state.game_won_events) == 0, 2);
        assert!(event::counter(&state.game_tied_events) == 0, 2);
        assert!(event::counter(&state.game_round_events) == 1, 2);
        assert!(event::counter(&state.game_expired_events) == 0, 2);
    }

    #[test(admin = @overmind, player_1 = @0xA, player_2 = @0xB)]
    #[expected_failure(abort_code = ETurnIsExpired, location = Self)]
    fun test_mark_space_failure_turn_is_expired(
        admin: &signer, 
        player_1: &signer, 
        player_2: &signer, 
    ) acquires State {
        let admin_address = signer::address_of(admin);
        let player_1_address = signer::address_of(player_1);
        let player_2_address = signer::address_of(player_2);
        account::create_account_for_test(admin_address);
        account::create_account_for_test(player_1_address);
        account::create_account_for_test(player_2_address);


        let aptos_framework = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&aptos_framework);
        let (burn_cap, mint_cap) =
            aptos_coin::initialize_for_test(&aptos_framework);

        coin::register<AptosCoin>(player_1);
        coin::register<AptosCoin>(player_2);

        init_module(admin);

        timestamp::fast_forward_seconds(61000);

        aptos_coin::mint(&aptos_framework, player_1_address, PRIZE_AMOUNT_APT);
        create_game(player_1, player_1_address, player_2_address);

        timestamp::fast_forward_seconds(3230);

        mark_space(player_1, 0, 1, 1);
        timestamp::fast_forward_seconds(900000);
        mark_space(player_2, 0, 2, 1);

        let resource_account_address = 
            account::create_resource_address(&admin_address, b"tic-tac-toe");
        let state = borrow_global<State>(resource_account_address);
        assert!(
            state.game_count == 1, 
            0
        );
        assert!(
            vector::length(&state.games) == 1, 
            0
        );

        let game = vector::borrow(&state.games, 0); 
        assert!(
            game.creator == player_1_address, 
            0
        );
        assert!(
            game.player_one == player_1_address,
            0
        );
        assert!(
            game.player_two == player_2_address,
            0
        );
        assert!(
            game.current_turn == 1,
            0
        );
        assert!(
            game.expiration_timestamp_seconds == 61000 + 3230 + 2500,
            0
        );
        assert!(
            game.spaces == vector[
                vector[option::none(), option::none(), option::none()],
                vector[option::none(), option::some(0), option::none()],
                vector[option::none(), option::none(), option::none()]
            ],
            0
        );
        assert!(
            option::is_none(&game.result),
            0
        );


        let resource_account_address = 
            account::create_resource_address(&admin_address, b"tic-tac-toe");
        let state = borrow_global<State>(resource_account_address);

        coin::destroy_burn_cap(burn_cap);
        coin::destroy_mint_cap(mint_cap);

        assert!(event::counter(&state.game_created_events) == 1, 2);
        assert!(event::counter(&state.game_won_events) == 0, 2);
        assert!(event::counter(&state.game_tied_events) == 0, 2);
        assert!(event::counter(&state.game_round_events) == 1, 2);
        assert!(event::counter(&state.game_expired_events) == 0, 2);
    }

    #[test(admin = @overmind, player_1 = @0xA, player_2 = @0xB)]
    #[expected_failure(abort_code = EInvalidSpaceIndices, location = Self)]
    fun test_mark_space_failure_invalid_space_1(
        admin: &signer, 
        player_1: &signer, 
        player_2: &signer, 
    ) acquires State {
        let admin_address = signer::address_of(admin);
        let player_1_address = signer::address_of(player_1);
        let player_2_address = signer::address_of(player_2);
        account::create_account_for_test(admin_address);
        account::create_account_for_test(player_1_address);
        account::create_account_for_test(player_2_address);


        let aptos_framework = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&aptos_framework);
        let (burn_cap, mint_cap) =
            aptos_coin::initialize_for_test(&aptos_framework);

        coin::register<AptosCoin>(player_1);
        coin::register<AptosCoin>(player_2);

        init_module(admin);

        timestamp::fast_forward_seconds(61000);

        aptos_coin::mint(&aptos_framework, player_1_address, PRIZE_AMOUNT_APT);
        create_game(player_1, player_1_address, player_2_address);

        timestamp::fast_forward_seconds(3230);

        mark_space(player_1, 0, 3, 3);

        let resource_account_address = 
            account::create_resource_address(&admin_address, b"tic-tac-toe");
        let state = borrow_global<State>(resource_account_address);
        assert!(
            state.game_count == 1, 
            0
        );
        assert!(
            vector::length(&state.games) == 1, 
            0
        );

        let game = vector::borrow(&state.games, 0); 
        assert!(
            game.creator == player_1_address, 
            0
        );
        assert!(
            game.player_one == player_1_address,
            0
        );
        assert!(
            game.player_two == player_2_address,
            0
        );
        assert!(
            game.current_turn == 1,
            0
        );
        assert!(
            game.expiration_timestamp_seconds == 61000 + 3230 + 2500,
            0
        );
        assert!(
            game.spaces == vector[
                vector[option::none(), option::none(), option::none()],
                vector[option::none(), option::some(0), option::none()],
                vector[option::none(), option::none(), option::none()]
            ],
            0
        );
        assert!(
            option::is_none(&game.result),
            0
        );


        let resource_account_address = 
            account::create_resource_address(&admin_address, b"tic-tac-toe");
        let state = borrow_global<State>(resource_account_address);

        coin::destroy_burn_cap(burn_cap);
        coin::destroy_mint_cap(mint_cap);

        assert!(event::counter(&state.game_created_events) == 1, 2);
        assert!(event::counter(&state.game_won_events) == 0, 2);
        assert!(event::counter(&state.game_tied_events) == 0, 2);
        assert!(event::counter(&state.game_round_events) == 1, 2);
        assert!(event::counter(&state.game_expired_events) == 0, 2);
    }

    #[test(admin = @overmind, player_1 = @0xA, player_2 = @0xB)]
    #[expected_failure(abort_code = EInvalidSpaceIndices, location = Self)]
    fun test_mark_space_failure_invalid_space_2(
        admin: &signer, 
        player_1: &signer, 
        player_2: &signer, 
    ) acquires State {
        let admin_address = signer::address_of(admin);
        let player_1_address = signer::address_of(player_1);
        let player_2_address = signer::address_of(player_2);
        account::create_account_for_test(admin_address);
        account::create_account_for_test(player_1_address);
        account::create_account_for_test(player_2_address);


        let aptos_framework = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&aptos_framework);
        let (burn_cap, mint_cap) =
            aptos_coin::initialize_for_test(&aptos_framework);

        coin::register<AptosCoin>(player_1);
        coin::register<AptosCoin>(player_2);

        init_module(admin);

        timestamp::fast_forward_seconds(61000);

        aptos_coin::mint(&aptos_framework, player_1_address, PRIZE_AMOUNT_APT);
        create_game(player_1, player_1_address, player_2_address);

        timestamp::fast_forward_seconds(3230);

        mark_space(player_1, 0, 1, 3);

        let resource_account_address = 
            account::create_resource_address(&admin_address, b"tic-tac-toe");
        let state = borrow_global<State>(resource_account_address);
        assert!(
            state.game_count == 1, 
            0
        );
        assert!(
            vector::length(&state.games) == 1, 
            0
        );

        let game = vector::borrow(&state.games, 0); 
        assert!(
            game.creator == player_1_address, 
            0
        );
        assert!(
            game.player_one == player_1_address,
            0
        );
        assert!(
            game.player_two == player_2_address,
            0
        );
        assert!(
            game.current_turn == 1,
            0
        );
        assert!(
            game.expiration_timestamp_seconds == 61000 + 3230 + 2500,
            0
        );
        assert!(
            game.spaces == vector[
                vector[option::none(), option::none(), option::none()],
                vector[option::none(), option::some(0), option::none()],
                vector[option::none(), option::none(), option::none()]
            ],
            0
        );
        assert!(
            option::is_none(&game.result),
            0
        );


        let resource_account_address = 
            account::create_resource_address(&admin_address, b"tic-tac-toe");
        let state = borrow_global<State>(resource_account_address);

        coin::destroy_burn_cap(burn_cap);
        coin::destroy_mint_cap(mint_cap);

        assert!(event::counter(&state.game_created_events) == 1, 2);
        assert!(event::counter(&state.game_won_events) == 0, 2);
        assert!(event::counter(&state.game_tied_events) == 0, 2);
        assert!(event::counter(&state.game_round_events) == 1, 2);
        assert!(event::counter(&state.game_expired_events) == 0, 2);
    }

    #[test(admin = @overmind, player_1 = @0xA, player_2 = @0xB)]
    #[expected_failure(abort_code = EInvalidSpaceIndices, location = Self)]
    fun test_mark_space_failure_invalid_space_3(
        admin: &signer, 
        player_1: &signer, 
        player_2: &signer, 
    ) acquires State {
        let admin_address = signer::address_of(admin);
        let player_1_address = signer::address_of(player_1);
        let player_2_address = signer::address_of(player_2);
        account::create_account_for_test(admin_address);
        account::create_account_for_test(player_1_address);
        account::create_account_for_test(player_2_address);


        let aptos_framework = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&aptos_framework);
        let (burn_cap, mint_cap) =
            aptos_coin::initialize_for_test(&aptos_framework);

        coin::register<AptosCoin>(player_1);
        coin::register<AptosCoin>(player_2);

        init_module(admin);

        timestamp::fast_forward_seconds(61000);

        aptos_coin::mint(&aptos_framework, player_1_address, PRIZE_AMOUNT_APT);
        create_game(player_1, player_1_address, player_2_address);

        timestamp::fast_forward_seconds(3230);

        mark_space(player_1, 0, 3, 1);

        let resource_account_address = 
            account::create_resource_address(&admin_address, b"tic-tac-toe");
        let state = borrow_global<State>(resource_account_address);
        assert!(
            state.game_count == 1, 
            0
        );
        assert!(
            vector::length(&state.games) == 1, 
            0
        );

        let game = vector::borrow(&state.games, 0); 
        assert!(
            game.creator == player_1_address, 
            0
        );
        assert!(
            game.player_one == player_1_address,
            0
        );
        assert!(
            game.player_two == player_2_address,
            0
        );
        assert!(
            game.current_turn == 1,
            0
        );
        assert!(
            game.expiration_timestamp_seconds == 61000 + 3230 + 2500,
            0
        );
        assert!(
            game.spaces == vector[
                vector[option::none(), option::none(), option::none()],
                vector[option::none(), option::some(0), option::none()],
                vector[option::none(), option::none(), option::none()]
            ],
            0
        );
        assert!(
            option::is_none(&game.result),
            0
        );


        let resource_account_address = 
            account::create_resource_address(&admin_address, b"tic-tac-toe");
        let state = borrow_global<State>(resource_account_address);

        coin::destroy_burn_cap(burn_cap);
        coin::destroy_mint_cap(mint_cap);

        assert!(event::counter(&state.game_created_events) == 1, 2);
        assert!(event::counter(&state.game_won_events) == 0, 2);
        assert!(event::counter(&state.game_tied_events) == 0, 2);
        assert!(event::counter(&state.game_round_events) == 1, 2);
        assert!(event::counter(&state.game_expired_events) == 0, 2);
    }

    #[test(admin = @overmind, player_1 = @0xA, player_2 = @0xB)]
    #[expected_failure(abort_code = ENotPlayersTurn, location = Self)]
    fun test_mark_space_failure_not_players_turn(
        admin: &signer, 
        player_1: &signer, 
        player_2: &signer, 
    ) acquires State {
        let admin_address = signer::address_of(admin);
        let player_1_address = signer::address_of(player_1);
        let player_2_address = signer::address_of(player_2);
        account::create_account_for_test(admin_address);
        account::create_account_for_test(player_1_address);
        account::create_account_for_test(player_2_address);


        let aptos_framework = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&aptos_framework);
        let (burn_cap, mint_cap) =
            aptos_coin::initialize_for_test(&aptos_framework);

        coin::register<AptosCoin>(player_1);
        coin::register<AptosCoin>(player_2);

        init_module(admin);

        timestamp::fast_forward_seconds(61000);

        aptos_coin::mint(&aptos_framework, player_1_address, PRIZE_AMOUNT_APT);
        create_game(player_1, player_1_address, player_2_address);

        timestamp::fast_forward_seconds(3230);

        mark_space(player_1, 0, 1, 1);
        mark_space(player_1, 0, 0, 0);
        mark_space(player_1, 0, 0, 1);

        let resource_account_address = 
            account::create_resource_address(&admin_address, b"tic-tac-toe");
        let state = borrow_global<State>(resource_account_address);
        assert!(
            state.game_count == 1, 
            0
        );
        assert!(
            vector::length(&state.games) == 1, 
            0
        );

        let game = vector::borrow(&state.games, 0); 
        assert!(
            game.creator == player_1_address, 
            0
        );
        assert!(
            game.player_one == player_1_address,
            0
        );
        assert!(
            game.player_two == player_2_address,
            0
        );
        assert!(
            game.current_turn == 1,
            0
        );
        assert!(
            game.expiration_timestamp_seconds == 61000 + 3230 + 2500,
            0
        );
        assert!(
            game.spaces == vector[
                vector[option::none(), option::none(), option::none()],
                vector[option::none(), option::some(0), option::none()],
                vector[option::none(), option::none(), option::none()]
            ],
            0
        );
        assert!(
            option::is_none(&game.result),
            0
        );


        let resource_account_address = 
            account::create_resource_address(&admin_address, b"tic-tac-toe");
        let state = borrow_global<State>(resource_account_address);

        coin::destroy_burn_cap(burn_cap);
        coin::destroy_mint_cap(mint_cap);

        assert!(event::counter(&state.game_created_events) == 1, 2);
        assert!(event::counter(&state.game_won_events) == 0, 2);
        assert!(event::counter(&state.game_tied_events) == 0, 2);
        assert!(event::counter(&state.game_round_events) == 1, 2);
        assert!(event::counter(&state.game_expired_events) == 0, 2);
    }


    #[test(admin = @overmind, player_1 = @0xA, player_2 = @0xB)]
    fun test_release_funds_after_expiration_success_funds_released_to_player_two(
        admin: &signer, 
        player_1: &signer, 
        player_2: &signer, 
    ) acquires State {
        let admin_address = signer::address_of(admin);
        let player_1_address = signer::address_of(player_1);
        let player_2_address = signer::address_of(player_2);
        account::create_account_for_test(admin_address);
        account::create_account_for_test(player_1_address);
        account::create_account_for_test(player_2_address);


        let aptos_framework = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&aptos_framework);
        let (burn_cap, mint_cap) =
            aptos_coin::initialize_for_test(&aptos_framework);

        coin::register<AptosCoin>(player_1);
        coin::register<AptosCoin>(player_2);
        coin::register<AptosCoin>(admin);

        init_module(admin);

        timestamp::fast_forward_seconds(61000);

        aptos_coin::mint(&aptos_framework, admin_address, PRIZE_AMOUNT_APT);
        create_game(admin, player_1_address, player_2_address);

        timestamp::fast_forward_seconds(3230);

        mark_space(player_1, 0, 1, 1);
        mark_space(player_2, 0, 0, 1);
        timestamp::fast_forward_seconds(1000);
        mark_space(player_1, 0, 2, 2);
        mark_space(player_2, 0, 0, 2);

        timestamp::fast_forward_seconds(10000);
        release_funds_after_expiration(0);

        let resource_account_address = 
            account::create_resource_address(&admin_address, b"tic-tac-toe");
        let state = borrow_global<State>(resource_account_address);
        assert!(
            state.game_count == 1, 
            0
        );
        assert!(
            vector::length(&state.games) == 1, 
            0
        );

        let game = vector::borrow(&state.games, 0); 
        assert!(
            game.creator == admin_address, 
            0
        );
        assert!(
            game.player_one == player_1_address,
            0
        );
        assert!(
            game.player_two == player_2_address,
            0
        );
        assert!(
            game.current_turn == 0,
            0
        );
        assert!(
            game.expiration_timestamp_seconds == 61000 + 3230 + 1000 + 2500,
            0
        );
        assert!(
            game.spaces == vector[
                vector[option::none(), option::some(1), option::some(1)],
                vector[option::none(), option::some(0), option::none()],
                vector[option::none(), option::none(), option::some(0)]
            ],
            0
        );
        assert!(
            option::contains(&game.result, &3) == true,
            0
        );

        assert!(
            coin::balance<AptosCoin>(player_1_address) == 0, 
            0
        );
        assert!(
            coin::balance<AptosCoin>(player_2_address) == 1000000000, 
            0
        );
        assert!(
            coin::balance<AptosCoin>(admin_address) == 0, 
            0
        );

        coin::destroy_burn_cap(burn_cap);
        coin::destroy_mint_cap(mint_cap);

        assert!(event::counter(&state.game_created_events) == 1, 2);
        assert!(event::counter(&state.game_won_events) == 0, 2);
        assert!(event::counter(&state.game_tied_events) == 0, 2);
        assert!(event::counter(&state.game_round_events) == 4, 2);
        assert!(event::counter(&state.game_expired_events) == 1, 2);
    }

    #[test(admin = @overmind, player_1 = @0xA, player_2 = @0xB)]
    fun test_release_funds_after_expiration_success_funds_released_to_player_one(
        admin: &signer, 
        player_1: &signer, 
        player_2: &signer, 
    ) acquires State {
        let admin_address = signer::address_of(admin);
        let player_1_address = signer::address_of(player_1);
        let player_2_address = signer::address_of(player_2);
        account::create_account_for_test(admin_address);
        account::create_account_for_test(player_1_address);
        account::create_account_for_test(player_2_address);


        let aptos_framework = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&aptos_framework);
        let (burn_cap, mint_cap) =
            aptos_coin::initialize_for_test(&aptos_framework);

        coin::register<AptosCoin>(player_1);
        coin::register<AptosCoin>(player_2);
        coin::register<AptosCoin>(admin);

        init_module(admin);

        timestamp::fast_forward_seconds(61000);

        aptos_coin::mint(&aptos_framework, admin_address, PRIZE_AMOUNT_APT);
        create_game(admin, player_1_address, player_2_address);

        timestamp::fast_forward_seconds(3230);

        mark_space(player_1, 0, 1, 1);
        mark_space(player_2, 0, 0, 1);
        timestamp::fast_forward_seconds(1000);
        mark_space(player_1, 0, 2, 2);

        timestamp::fast_forward_seconds(10000);
        release_funds_after_expiration(0);

        let resource_account_address = 
            account::create_resource_address(&admin_address, b"tic-tac-toe");
        let state = borrow_global<State>(resource_account_address);
        assert!(
            state.game_count == 1, 
            0
        );
        assert!(
            vector::length(&state.games) == 1, 
            0
        );

        let game = vector::borrow(&state.games, 0); 
        assert!(
            game.creator == admin_address, 
            0
        );
        assert!(
            game.player_one == player_1_address,
            0
        );
        assert!(
            game.player_two == player_2_address,
            0
        );
        assert!(
            game.current_turn == 1,
            0
        );
        assert!(
            game.expiration_timestamp_seconds == 61000 + 3230 + 1000 + 2500,
            0
        );
        assert!(
            game.spaces == vector[
                vector[option::none(), option::some(1), option::none()],
                vector[option::none(), option::some(0), option::none()],
                vector[option::none(), option::none(), option::some(0)]
            ],
            0
        );
        assert!(
            option::contains(&game.result, &3) == true,
            0
        );

        assert!(
            coin::balance<AptosCoin>(player_1_address) == 1000000000, 
            0
        );
        assert!(
            coin::balance<AptosCoin>(player_2_address) == 0, 
            0
        );
        assert!(
            coin::balance<AptosCoin>(admin_address) == 0, 
            0
        );

        coin::destroy_burn_cap(burn_cap);
        coin::destroy_mint_cap(mint_cap);

        assert!(event::counter(&state.game_created_events) == 1, 2);
        assert!(event::counter(&state.game_won_events) == 0, 2);
        assert!(event::counter(&state.game_tied_events) == 0, 2);
        assert!(event::counter(&state.game_round_events) == 3, 2);
        assert!(event::counter(&state.game_expired_events) == 1, 2);
    }

    #[test(admin = @overmind, player_1 = @0xA, player_2 = @0xB)]
    #[expected_failure(abort_code = EInvalidGameId, location = Self)]
    fun test_release_funds_after_expiration_failure_game_id_invalid(
        admin: &signer, 
        player_1: &signer, 
        player_2: &signer, 
    ) acquires State {
        let admin_address = signer::address_of(admin);
        let player_1_address = signer::address_of(player_1);
        let player_2_address = signer::address_of(player_2);
        account::create_account_for_test(admin_address);
        account::create_account_for_test(player_1_address);
        account::create_account_for_test(player_2_address);


        let aptos_framework = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&aptos_framework);
        let (burn_cap, mint_cap) =
            aptos_coin::initialize_for_test(&aptos_framework);

        coin::register<AptosCoin>(player_1);
        coin::register<AptosCoin>(player_2);
        coin::register<AptosCoin>(admin);

        init_module(admin);

        timestamp::fast_forward_seconds(61000);

        aptos_coin::mint(&aptos_framework, admin_address, PRIZE_AMOUNT_APT);
        create_game(admin, player_1_address, player_2_address);

        timestamp::fast_forward_seconds(3230);

        mark_space(player_1, 0, 1, 1);
        mark_space(player_2, 0, 0, 1);
        timestamp::fast_forward_seconds(1000);
        mark_space(player_1, 0, 2, 2);
        mark_space(player_2, 0, 0, 2);

        timestamp::fast_forward_seconds(10000);
        release_funds_after_expiration(1);

        let resource_account_address = 
            account::create_resource_address(&admin_address, b"tic-tac-toe");
        let state = borrow_global<State>(resource_account_address);
        assert!(
            state.game_count == 1, 
            0
        );
        assert!(
            vector::length(&state.games) == 1, 
            0
        );

        let game = vector::borrow(&state.games, 0); 
        assert!(
            game.creator == admin_address, 
            0
        );
        assert!(
            game.player_one == player_1_address,
            0
        );
        assert!(
            game.player_two == player_2_address,
            0
        );
        assert!(
            game.current_turn == 0,
            0
        );
        assert!(
            game.expiration_timestamp_seconds == 61000 + 3230 + 1000 + 2500,
            0
        );
        assert!(
            game.spaces == vector[
                vector[option::none(), option::some(1), option::some(1)],
                vector[option::none(), option::some(0), option::none()],
                vector[option::none(), option::none(), option::some(0)]
            ],
            0
        );
        assert!(
            option::contains(&game.result, &3) == true,
            0
        );

        assert!(
            coin::balance<AptosCoin>(player_1_address) == 0, 
            0
        );
        assert!(
            coin::balance<AptosCoin>(player_2_address) == PRIZE_AMOUNT_APT, 
            0
        );
        assert!(
            coin::balance<AptosCoin>(admin_address) == 0, 
            0
        );

        coin::destroy_burn_cap(burn_cap);
        coin::destroy_mint_cap(mint_cap);

        assert!(event::counter(&state.game_created_events) == 1, 2);
        assert!(event::counter(&state.game_won_events) == 0, 2);
        assert!(event::counter(&state.game_tied_events) == 0, 2);
        assert!(event::counter(&state.game_round_events) == 4, 2);
        assert!(event::counter(&state.game_expired_events) == 1, 2);
    }

    #[test(admin = @overmind, player_1 = @0xA, player_2 = @0xB)]
    #[expected_failure(abort_code = EGameIsNotExpired, location = Self)]
    fun test_release_funds_after_expiration_failure_game_is_not_expired(
        admin: &signer, 
        player_1: &signer, 
        player_2: &signer, 
    ) acquires State {
        let admin_address = signer::address_of(admin);
        let player_1_address = signer::address_of(player_1);
        let player_2_address = signer::address_of(player_2);
        account::create_account_for_test(admin_address);
        account::create_account_for_test(player_1_address);
        account::create_account_for_test(player_2_address);


        let aptos_framework = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&aptos_framework);
        let (burn_cap, mint_cap) =
            aptos_coin::initialize_for_test(&aptos_framework);

        coin::register<AptosCoin>(player_1);
        coin::register<AptosCoin>(player_2);
        coin::register<AptosCoin>(admin);

        init_module(admin);

        timestamp::fast_forward_seconds(61000);

        aptos_coin::mint(&aptos_framework, admin_address, PRIZE_AMOUNT_APT);
        create_game(admin, player_1_address, player_2_address);

        timestamp::fast_forward_seconds(3230);

        mark_space(player_1, 0, 1, 1);
        mark_space(player_2, 0, 0, 1);
        timestamp::fast_forward_seconds(1000);
        mark_space(player_1, 0, 2, 2);
        mark_space(player_2, 0, 0, 2);

        release_funds_after_expiration(0);

        let resource_account_address = 
            account::create_resource_address(&admin_address, b"tic-tac-toe");
        let state = borrow_global<State>(resource_account_address);
        assert!(
            state.game_count == 1, 
            0
        );
        assert!(
            vector::length(&state.games) == 1, 
            0
        );

        let game = vector::borrow(&state.games, 0); 
        assert!(
            game.creator == admin_address, 
            0
        );
        assert!(
            game.player_one == player_1_address,
            0
        );
        assert!(
            game.player_two == player_2_address,
            0
        );
        assert!(
            game.current_turn == 0,
            0
        );
        assert!(
            game.expiration_timestamp_seconds == 61000 + 3230 + 1000 + 2500,
            0
        );
        assert!(
            game.spaces == vector[
                vector[option::none(), option::some(1), option::some(1)],
                vector[option::none(), option::some(0), option::none()],
                vector[option::none(), option::none(), option::some(0)]
            ],
            0
        );
        assert!(
            option::contains(&game.result, &3) == true,
            0
        );

        assert!(
            coin::balance<AptosCoin>(player_1_address) == 0, 
            0
        );
        assert!(
            coin::balance<AptosCoin>(player_2_address) == PRIZE_AMOUNT_APT, 
            0
        );
        assert!(
            coin::balance<AptosCoin>(admin_address) == 0, 
            0
        );

        coin::destroy_burn_cap(burn_cap);
        coin::destroy_mint_cap(mint_cap);

        assert!(event::counter(&state.game_created_events) == 1, 2);
        assert!(event::counter(&state.game_won_events) == 0, 2);
        assert!(event::counter(&state.game_tied_events) == 0, 2);
        assert!(event::counter(&state.game_round_events) == 4, 2);
        assert!(event::counter(&state.game_expired_events) == 1, 2);
    }

    #[test(admin = @overmind, player_1 = @0xA, player_2 = @0xB)]
    #[expected_failure(abort_code = EPrizeAlreadyClaimed, location = Self)]
    fun test_release_funds_after_expiration_failure_prize_already_claimed(
        admin: &signer, 
        player_1: &signer, 
        player_2: &signer, 
    ) acquires State {
        let admin_address = signer::address_of(admin);
        let player_1_address = signer::address_of(player_1);
        let player_2_address = signer::address_of(player_2);
        account::create_account_for_test(admin_address);
        account::create_account_for_test(player_1_address);
        account::create_account_for_test(player_2_address);


        let aptos_framework = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&aptos_framework);
        let (burn_cap, mint_cap) =
            aptos_coin::initialize_for_test(&aptos_framework);

        coin::register<AptosCoin>(player_1);
        coin::register<AptosCoin>(player_2);
        coin::register<AptosCoin>(admin);

        init_module(admin);

        timestamp::fast_forward_seconds(61000);

        aptos_coin::mint(&aptos_framework, admin_address, PRIZE_AMOUNT_APT);
        create_game(admin, player_1_address, player_2_address);

        timestamp::fast_forward_seconds(3230);

        mark_space(player_1, 0, 1, 1);
        mark_space(player_2, 0, 0, 1);
        timestamp::fast_forward_seconds(1000);
        mark_space(player_1, 0, 2, 2);
        mark_space(player_2, 0, 0, 2);

        timestamp::fast_forward_seconds(10000);
        release_funds_after_expiration(0);
        release_funds_after_expiration(0);

        let resource_account_address = 
            account::create_resource_address(&admin_address, b"tic-tac-toe");
        let state = borrow_global<State>(resource_account_address);
        assert!(
            state.game_count == 1, 
            0
        );
        assert!(
            vector::length(&state.games) == 1, 
            0
        );

        let game = vector::borrow(&state.games, 0); 
        assert!(
            game.creator == admin_address, 
            0
        );
        assert!(
            game.player_one == player_1_address,
            0
        );
        assert!(
            game.player_two == player_2_address,
            0
        );
        assert!(
            game.current_turn == 0,
            0
        );
        assert!(
            game.expiration_timestamp_seconds == 61000 + 3230 + 1000 + 2500,
            0
        );
        assert!(
            game.spaces == vector[
                vector[option::none(), option::some(1), option::some(1)],
                vector[option::none(), option::some(0), option::none()],
                vector[option::none(), option::none(), option::some(0)]
            ],
            0
        );
        assert!(
            option::contains(&game.result, &3) == true,
            0
        );

        assert!(
            coin::balance<AptosCoin>(player_1_address) == 0, 
            0
        );
        assert!(
            coin::balance<AptosCoin>(player_2_address) == PRIZE_AMOUNT_APT, 
            0
        );
        assert!(
            coin::balance<AptosCoin>(admin_address) == 0, 
            0
        );

        coin::destroy_burn_cap(burn_cap);
        coin::destroy_mint_cap(mint_cap);

        assert!(event::counter(&state.game_created_events) == 1, 2);
        assert!(event::counter(&state.game_won_events) == 0, 2);
        assert!(event::counter(&state.game_tied_events) == 0, 2);
        assert!(event::counter(&state.game_round_events) == 4, 2);
        assert!(event::counter(&state.game_expired_events) == 1, 2);
    }

    #[test]
    fun test_win_detection_success_empty_board() {

        let spaces = vector[
            vector[option::none(), option::none(), option::none()],
            vector[option::none(), option::none(), option::none()],
            vector[option::none(), option::none(), option::none()]
        ];

        assert!(
            player_has_won(&spaces, 0, 0, 0) == false, 
            0
        );
        assert!(
            row_is_filled_by_player(&spaces, 0, 0) == false, 
            0
        );
        assert!(
            col_is_filled_by_player(&spaces, 0, 0) == false, 
            0
        );
        assert!(
            diagonal_is_filled_by_player(&spaces, 0) == false, 
            0
        );
        assert!(
            left_to_right_diagonal_is_filled_by_player(&spaces, 0) == false, 
            0
        );
        assert!(
            right_to_left_diagonal_is_filled_by_player(&spaces, 0) == false, 
            0
        );

        assert!(
            player_has_won(&spaces, 0, 0, 1) == false, 
            0
        );
        assert!(
            row_is_filled_by_player(&spaces, 0, 1) == false, 
            0
        );
        assert!(
            col_is_filled_by_player(&spaces, 0, 1) == false, 
            0
        );
        assert!(
            diagonal_is_filled_by_player(&spaces, 1) == false, 
            0
        );
        assert!(
            left_to_right_diagonal_is_filled_by_player(&spaces, 1) == false, 
            0
        );
        assert!(
            right_to_left_diagonal_is_filled_by_player(&spaces, 1) == false, 
            0
        );
    }

    #[test]
    fun test_win_detection_success_1() {

        let spaces = vector[
            vector[option::some(0), option::some(1), option::none()],
            vector[option::some(0), option::none(), option::some(1)],
            vector[option::some(0), option::some(1), option::none()]
        ];

        assert!(
            player_has_won(&spaces, 0, 0, 0) == true, 
            0
        );
        assert!(
            row_is_filled_by_player(&spaces, 0, 0) == false, 
            0
        );
        assert!(
            col_is_filled_by_player(&spaces, 0, 0) == true, 
            0
        );
        assert!(
            diagonal_is_filled_by_player(&spaces, 0) == false, 
            0
        );
        assert!(
            left_to_right_diagonal_is_filled_by_player(&spaces, 0) == false, 
            0
        );
        assert!(
            right_to_left_diagonal_is_filled_by_player(&spaces, 0) == false, 
            0
        );

        assert!(
            player_has_won(&spaces, 0, 0, 1) == false, 
            0
        );
        assert!(
            row_is_filled_by_player(&spaces, 0, 1) == false, 
            0
        );
        assert!(
            col_is_filled_by_player(&spaces, 0, 1) == false, 
            0
        );
        assert!(
            diagonal_is_filled_by_player(&spaces, 1) == false, 
            0
        );
        assert!(
            left_to_right_diagonal_is_filled_by_player(&spaces, 1) == false, 
            0
        );
        assert!(
            right_to_left_diagonal_is_filled_by_player(&spaces, 1) == false, 
            0
        );
    }

    #[test]
    fun test_win_detection_success_2() {

        let spaces = vector[
            vector[option::some(0), option::some(1), option::none()],
            vector[option::some(1), option::some(0), option::some(1)],
            vector[option::some(0), option::some(1), option::none()]
        ];

        assert!(
            player_has_won(&spaces, 0, 0, 0) == false, 
            0
        );
        assert!(
            row_is_filled_by_player(&spaces, 0, 0) == false, 
            0
        );
        assert!(
            col_is_filled_by_player(&spaces, 0, 0) == false, 
            0
        );
        assert!(
            diagonal_is_filled_by_player(&spaces, 0) == false, 
            0
        );
        assert!(
            left_to_right_diagonal_is_filled_by_player(&spaces, 0) == false, 
            0
        );
        assert!(
            right_to_left_diagonal_is_filled_by_player(&spaces, 0) == false, 
            0
        );

        assert!(
            player_has_won(&spaces, 0, 0, 1) == false, 
            0
        );
        assert!(
            row_is_filled_by_player(&spaces, 0, 1) == false, 
            0
        );
        assert!(
            col_is_filled_by_player(&spaces, 0, 1) == false, 
            0
        );
        assert!(
            diagonal_is_filled_by_player(&spaces, 1) == false, 
            0
        );
        assert!(
            left_to_right_diagonal_is_filled_by_player(&spaces, 1) == false, 
            0
        );
        assert!(
            right_to_left_diagonal_is_filled_by_player(&spaces, 1) == false, 
            0
        );
    }

    #[test]
    fun test_win_detection_success_3() {

        let spaces = vector[
            vector[option::some(0), option::some(1), option::none()],
            vector[option::some(1), option::some(0), option::some(1)],
            vector[option::some(0), option::some(1), option::some(0)]
        ];

        assert!(
            player_has_won(&spaces, 0, 0, 0) == true, 
            0
        );
        assert!(
            row_is_filled_by_player(&spaces, 0, 0) == false, 
            0
        );
        assert!(
            col_is_filled_by_player(&spaces, 0, 0) == false, 
            0
        );
        assert!(
            diagonal_is_filled_by_player(&spaces, 0) == true, 
            0
        );
        assert!(
            left_to_right_diagonal_is_filled_by_player(&spaces, 0) == true, 
            0
        );
        assert!(
            right_to_left_diagonal_is_filled_by_player(&spaces, 0) == false, 
            0
        );

        assert!(
            player_has_won(&spaces, 0, 0, 1) == false, 
            0
        );
        assert!(
            row_is_filled_by_player(&spaces, 0, 1) == false, 
            0
        );
        assert!(
            col_is_filled_by_player(&spaces, 0, 1) == false, 
            0
        );
        assert!(
            diagonal_is_filled_by_player(&spaces, 1) == false, 
            0
        );
        assert!(
            left_to_right_diagonal_is_filled_by_player(&spaces, 1) == false, 
            0
        );
        assert!(
            right_to_left_diagonal_is_filled_by_player(&spaces, 1) == false, 
            0
        );
    }

    #[test]
    fun test_win_detection_success_4() {

        let spaces = vector[
            vector[option::some(0), option::some(1), option::none()],
            vector[option::some(0), option::some(1), option::some(1)],
            vector[option::some(0), option::some(1), option::some(0)]
        ];

        assert!(
            player_has_won(&spaces, 0, 0, 0) == true, 
            0
        );
        assert!(
            row_is_filled_by_player(&spaces, 0, 0) == false, 
            0
        );
        assert!(
            col_is_filled_by_player(&spaces, 0, 0) == true, 
            0
        );
        assert!(
            diagonal_is_filled_by_player(&spaces, 0) == false, 
            0
        );
        assert!(
            left_to_right_diagonal_is_filled_by_player(&spaces, 0) == false, 
            0
        );
        assert!(
            right_to_left_diagonal_is_filled_by_player(&spaces, 0) == false, 
            0
        );

        assert!(
            player_has_won(&spaces, 0, 0, 1) == false, 
            0
        );
        assert!(
            row_is_filled_by_player(&spaces, 0, 1) == false, 
            0
        );
        assert!(
            col_is_filled_by_player(&spaces, 0, 1) == false, 
            0
        );
        assert!(
            diagonal_is_filled_by_player(&spaces, 1) == false, 
            0
        );
        assert!(
            left_to_right_diagonal_is_filled_by_player(&spaces, 1) == false, 
            0
        );
        assert!(
            right_to_left_diagonal_is_filled_by_player(&spaces, 1) == false, 
            0
        );
    }

    #[test]
    fun test_win_detection_success_5() {

        let spaces = vector[
            vector[option::some(0), option::some(1), option::none()],
            vector[option::some(0), option::some(1), option::some(1)],
            vector[option::some(0), option::some(1), option::some(0)]
        ];

        assert!(
            player_has_won(&spaces, 0, 0, 0) == true, 
            0
        );
        assert!(
            row_is_filled_by_player(&spaces, 0, 0) == false, 
            0
        );
        assert!(
            col_is_filled_by_player(&spaces, 0, 0) == true, 
            0
        );
        assert!(
            diagonal_is_filled_by_player(&spaces, 0) == false, 
            0
        );
        assert!(
            left_to_right_diagonal_is_filled_by_player(&spaces, 0) == false, 
            0
        );
        assert!(
            right_to_left_diagonal_is_filled_by_player(&spaces, 0) == false, 
            0
        );

        assert!(
            player_has_won(&spaces, 1, 1, 1) == true, 
            0
        );
        assert!(
            row_is_filled_by_player(&spaces, 1, 1) == false, 
            0
        );
        assert!(
            col_is_filled_by_player(&spaces, 1, 1) == true, 
            0
        );
        assert!(
            diagonal_is_filled_by_player(&spaces, 1) == false, 
            0
        );
        assert!(
            left_to_right_diagonal_is_filled_by_player(&spaces, 1) == false, 
            0
        );
        assert!(
            right_to_left_diagonal_is_filled_by_player(&spaces, 1) == false, 
            0
        );
    }

    #[test]
    fun test_game_spaces_are_full_success_full_1() {

        let spaces = vector[
            vector[option::some(0), option::some(1), option::some(1)],
            vector[option::some(0), option::some(1), option::some(1)],
            vector[option::some(0), option::some(1), option::some(0)]
        ];

        assert!(
            game_spaces_are_full(&spaces) == true, 
            0
        );
        
    }

    #[test]
    fun test_game_spaces_are_full_success_not_full_1() {

        let spaces = vector[
            vector[option::some(0), option::some(1), option::some(1)],
            vector[option::none(), option::some(1), option::some(1)],
            vector[option::some(0), option::some(1), option::some(0)]
        ];

        assert!(
            game_spaces_are_full(&spaces) == false, 
            0
        );
        
    }

    #[test]
    fun test_get_resource_account_address_success() {

        assert!(
            get_resource_account_address() == account::create_resource_address(&@overmind, SEED), 
            0
        );
        
    }
    
}