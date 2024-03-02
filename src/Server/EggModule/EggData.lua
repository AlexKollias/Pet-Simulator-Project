return{
    Egg1 = {
        Name = "Egg1";
        Price = 10;
        Pets = {
            Cat1 = {
                Name = "Cat1";
                Rarity = "Common";
                Chance = 49; --In % meaning it is 0.555 in 0-1 scale
                Location = game.ReplicatedStorage.Pets.Egg1.Cat1;
                Amount = 0;
            };
            Cat2 = {
                Name = "Cat2";
                Rarity = "Common";
                Chance = 51; --In % meaning it is 0.555 in 0-1 scale
                Location = game.ReplicatedStorage.Pets.Egg1.Cat2;
                Amount = 0;
            }
        }
    }
}