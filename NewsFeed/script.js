let currentPage = 1;
let NewsArticle = [
    {
        Title: "AI in Healthcare Revolution",
        Description: "Advanced AI technologies transforming medical diagnostics and patient care.",
        imgURL: "https://www.mindinventory.com/blog/wp-content/uploads/2023/10/ai-in-healthcare-industry.webp"
    },
    {
        Title: "Climate Change Solutions",
        Description: "Global strategies for reducing carbon emissions and promoting sustainability.",
        imgURL: "https://images.unsplash.com/photo-1516321497487-e288fb19713f"
    },
    {
        Title: "Space Exploration Frontier",
        Description: "Breakthrough discoveries in deep space exploration and cosmic research.",
        imgURL: "https://images.unsplash.com/photo-1614730321146-b6fa6a46bcb4"
    },
    {
        Title: "Renewable Energy Tech",
        Description: "Innovative technologies making sustainable energy more accessible.",
        imgURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQJS849dEWrvrFWPOAWJCzIDRQFCm7MVQ8Yjw&s"
    },
    {
        Title: "Digital Learning Revolution",
        Description: "Transformative digital platforms reshaping global education.",
        imgURL: "https://img.freepik.com/premium-photo/digital-learning-revolution-empowering-education-throu-4xjpg_835197-13497.jpg"
    },
    {
        Title: "Future Tech Landscape",
        Description: "Emerging technologies set to transform everyday life.",
        imgURL: "https://images.unsplash.com/photo-1454165804606-c3d57bc86b40"
    }
];

function loadNewsFeed() {
    const container = document.getElementById("newsContainer");
    container.innerHTML = "";

    const startIndex = (currentPage - 1) * 6;
    const endIndex = startIndex + 6;
    const pageArticles = NewsArticle.slice(startIndex, endIndex);

    pageArticles.forEach(article => {
        const newsItem = `
            <div class="card transform transition-all duration-300 hover:-translate-y-2">
                <img src="${article.imgURL}" alt="${article.Title}" class="card-image w-full">
                <div class="p-4">
                    <h3 class="text-xl font-bold mb-2 text-gray-200">${article.Title}</h3>
                    <p class="text-gray-400">${article.Description}</p>
                </div>
            </div>
        `;
        container.innerHTML += newsItem;
    });
}

document.getElementById("newsForm").addEventListener("submit", function(event) {
    event.preventDefault();
    const Title = document.getElementById("title").value;
    const Description = document.getElementById("description").value;
    const imgURL = document.getElementById("imgUrl").value;
    
    NewsArticle.push({ Title, Description, imgURL });
    this.reset();
    loadNewsFeed();
});

function changePage(delta) {
    currentPage = Math.max(1, Math.min(Math.ceil(NewsArticle.length / 6), currentPage + delta));
    loadNewsFeed();
}

function goToPage(page) {
    currentPage = page;
    loadNewsFeed();
}

window.onload = loadNewsFeed;