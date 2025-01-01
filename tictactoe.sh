#!/bin/bash

# Initialize the board
board=(" " " " " " " " " " " " " " " " " ")

# Function to display the board
display_board() {
    clear
    echo " ${board[0]} | ${board[1]} | ${board[2]} "
    echo "---+---+---"
    echo " ${board[3]} | ${board[4]} | ${board[5]} "
    echo "---+---+---"
    echo " ${board[6]} | ${board[7]} | ${board[8]} "
}

# Function to check for a win
check_win() {
    # Winning combinations
    local wins=(
        "0 1 2"
        "3 4 5"
        "6 7 8"
        "0 3 6"
        "1 4 7"
        "2 5 8"
        "0 4 8"
        "2 4 6"
    )

    for combo in "${wins[@]}"; do
        read -r a b c <<< "$combo"
        if [[ ${board[$a]} != " " ]] && 
           [[ ${board[$a]} == ${board[$b]} ]] && 
           [[ ${board[$a]} == ${board[$c]} ]]; then
            echo "${board[$a]}"
            return 0
        fi
    done
    return 1
}

# Function to check for a draw
check_draw() {
    for cell in "${board[@]}"; do
        if [[ $cell == " " ]]; then
            return 1
        fi
    done
    return 0
}

# Main game loop
main() {
    local current_player="X"
    local game_over=false

    while [[ $game_over == false ]]; do
        display_board

        # Player input
        echo "Player $current_player's turn"
        read -p "Enter position (1-9): " position

        # Validate input
        if [[ ! $position =~ ^[1-9]$ ]]; then
            echo "Invalid input. Choose a number between 1 and 9."
            sleep 2
            continue
        fi

        # Adjust position to zero-based index
        ((position--))

        # Check if position is already occupied
        if [[ ${board[$position]} != " " ]]; then
            echo "Position already occupied. Try again."
            sleep 2
            continue
        fi

        # Place player's mark
        board[$position]=$current_player

        # Check for win
        if check_win; then
            display_board
            echo "Player $current_player wins!"
            game_over=true
            break
        fi

        # Check for draw
        if check_draw; then
            display_board
            echo "It's a draw!"
            game_over=true
            break
        fi

        # Switch players
        current_player=$([ "$current_player" == "X" ] && echo "O" || echo "X")
    done

    # Ask to play again
    read -p "Play again? (y/n): " play_again
    if [[ $play_again == "y" ]]; then
        # Reset board
        board=(" " " " " " " " " " " " " " " " " ")
        main
    fi
}

# Start the game
echo "Welcome to Tic-Tac-Toe!"
main