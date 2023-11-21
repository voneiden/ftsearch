<script>
    import {onMount} from "svelte";
    import sonicUrl from "./assets/sonic.gif";

    let query = "";
    let language = "fi";
    let apiData = null;
    let selectedHost = 'https://linkedevents.api.stage.hel.ninja';
    const options = [
        'http://localhost:8000',
        'https://linkedevents.api.dev.hel.ninja',
        "https://linkedevents.api.test.hel.ninja",
        "https://linkedevents.api.stage.hel.ninja",
        "https://api.hel.fi/linkedevents"
    ];

    function handleOnSubmit() {

        apiData = null;
        //fetch(`http://127.0.0.1:8000/v1/event/?x_full_text=${query}&x_full_text_language=${language}&include=location,keywords`)
        fetch(`${selectedHost}/v1/event/?x_full_text=${query}&x_full_text_language=${language}&include=location,keywords`)
            .then(response => response.json())
            .then(data => {
                console.log(data);
                apiData = data;
            }).catch(error => {
            console.log(error);
            return [];
        });
        return true;
    }

    onMount(async () => {
        handleOnSubmit()
    });

    

    // Function to handle the change event of the select dropdown
    function handleSelectChange(event) {
        selectedHost = event.target.value;
        handleOnSubmit();
    }
</script>

<main>
    <h1>Linked Full Text</h1>
    <select id="selectOption" bind:value={selectedHost} on:change={handleSelectChange}>
        {#each options as option (option)}
            <option value={option}>{option}</option>
        {/each}
    </select>
    <form on:submit|preventDefault={handleOnSubmit}>
        <input bind:value={query}>
        <select
                bind:value={language}
        >
            <option value="fi">fi</option>
            <option value="en">en</option>
            <option value="sv">sv</option>
        </select>
        <button type="submit">
            Search
        </button>
    </form>
    <ul>
        {#if apiData === null}
            <img style="height: 50px" src={sonicUrl}/>
        
        {:else if apiData.length === 0}
            No results
        {:else}
            <div><b>Total count:</b> {apiData.meta.count}</div>
            {#each apiData.data as event}
                <li>{event.name && event.name[language]}
                    <ul>
                        <li><b>ID:</b> {event.id}</li>
                        <li><b>Lyhyt kuvaus:</b> {event.short_description && event.short_description[language]}</li>
                        <li class="longdesc"><b>Pitkä
                            kuvaus</b> {@html event.description && event.description[language]}</li>
                        <li><b>Paikka:</b>{event.location?.name && event.location.name[language]}</li>
                        <li><b>Avainsanat:</b> {event.keywords.map(kw => kw.name && kw.name[language]).join(", ")}</li>
                    </ul>
                </li>
            {/each}
        {/if}
    </ul>
</main>

<style>

</style>