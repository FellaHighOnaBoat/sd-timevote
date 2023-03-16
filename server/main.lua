local voteActive = false
local yesVotes = 0
local noVotes = 0
ESX = exports["es_extended"]:getSharedObject()


local function startVote()
    if not voteActive then
        voteActive = true
        yesVotes = 0
        noVotes = 0
        hasVoted = false
        local message = 'A vote has started to skip the night. Type /yes or /no to vote.'
        if Config.NotificationType == 'chat' then
            print('chatmessage')
            TriggerClientEvent('chat:addMessage', -1, {color = {255, 255, 0}, multiline = true, args = {'Vote Time', message}})
        elseif Config.NotificationType == 'notification' then
            if Config.Framework == 'QB' then
                TriggerClientEvent('QBCore:Notify', -1, message, "success", 5000)
            elseif Config.Framework == 'ESX' then
                local xPlayer = ESX.GetPlayerFromId(source)
                xPlayer.showNotification(message, false, false, 140)
            end
        end
        TriggerClientEvent('sd-votetime:client:startVote', -1)
        SetTimeout(60000, function()
            voteActive = false
            if yesVotes > noVotes then
                if Config.Framework == 'QB' then
                    exports["qb-weathersync"]:setTime(8, 10)
                    TriggerClientEvent('sd-votetime:client:setTimeToDay', -1)
                elseif Config.Framework == 'ESX' then
                    TriggerClientEvent('sd-votetime:setdaybro')
                end
            else
                TriggerClientEvent('sd-votetime:client:voteFailed', -1)
            end
        end)
    end
end

RegisterServerEvent('sd-votetime:server:startVote')
AddEventHandler('sd-votetime:server:startVote', function(source, args)
    startVote()
end)

RegisterServerEvent('sd-votetime:server:resetVotes')
AddEventHandler('sd-votetime:server:resetVotes', function()
    yesVotes = 0
    noVotes = 0
end)

RegisterServerEvent('sd-votetime:server:playerVoted')
AddEventHandler('sd-votetime:server:playerVoted', function(vote)
    if vote == 'yes' then
        yesVotes = yesVotes + 1
    elseif vote == 'no' then
        noVotes = noVotes + 1
    end
end)
