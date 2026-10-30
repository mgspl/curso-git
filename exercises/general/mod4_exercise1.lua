-- Feito com base em: https://www.geeksforgeeks.org/dsa/quick-sort-algorithm/
-- "Corrigido" com: https://www.tutorialspoint.com/lua/lua_quick_sort.htm
-- Usado para alterar o jeito de particionar: https://www.geeksforgeeks.org/dsa/hoares-vs-lomuto-partition-scheme-quicksort/
-- Usado para otimizar o tail recursion: https://www.geeksforgeeks.org/dsa/quicksort-tail-call-optimization-reducing-worst-case-space-log-n/
local function partition(array, low, high)
    local pivot = array[high]
    local i = low - 1

    for j = low, high - 1 do
        if array[j] <= pivot then
            i = i + 1
            array[i], array[j] = array[j], array[i]
        end
    end

    array[i + 1], array[high] = array[high], array[i + 1]
    return i + 1
end

local function quickSort(t, low, high)
    if low < high then
        local pi = partition(t, low, high)
        quickSort(t, low, pi -1)
        quickSort(t, pi + 1, high)
    end
    return t
end

local function hoarePartition(array, low, high)
    local pivot = array[low]
    local i = low  - 1
    local j = high + 1

    while true do
        i = i + 1
        while array[i] < pivot do
            i = i + 1
        end
        j = j - 1
        while array[j] > pivot do
            j = j - 1
        end

        if i >= j then
            return j
        end

        array[i], array[j] = array[j], array[i]
    end
end

local function quickSortHoareTail(array, low, high)
    while low < high do
        local pivot = hoarePartition(array, low, high)

        if pivot - low < high - low then
            quickSortHoareTail(array, low, pivot - 1)
            low = pivot + 1
        else
            quickSortHoareTail(array, pivot + 1, high)
            high = pivot - 1
        end
    end
end

math.randomseed(os.clock())
local totalNumbers = 10910 -- higher number = stackOverflow on luajit
local array = {}
for i = 1, totalNumbers, 1 do
    table.insert(array, math.random(totalNumbers))
end

-- n Log n ( Array desordenado)
quickSort(array, 1, #array)


-- n² ( Array ordenado)
local t1 = os.clock()
quickSort(array, 1, #array)
local t2 = os.clock()
print("Tempo não otimizado: ", (t2 - t1) * 1000, "ms")


local t3 = os.clock()
quickSortHoareTail(array, 1, #array)
local t4 = os.clock()
print("Tempo otimizado: ", (t4 - t3) * 1000, "ms")
