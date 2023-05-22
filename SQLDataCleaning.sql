/*
Cleaning Data in SQL Queries
*/


Select *
From PortfolioProject1.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


Select saleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProject1.dbo.NashvilleHousing


Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)
-------------------------------------------------------------
--Populate property Address data
Select *
From PortfolioProject1.dbo.NashvilleHousing
--where PropertyAddress is null 
order by ParcelID
Select a.ParcelID ,a.PropertyAddress,b.ParcelID, b.PropertyAddress, ISNULL(A.PropertyAddress,B.PropertyAddress)
From PortfolioProject1.dbo.NashvilleHousing A
join  PortfolioProject1.dbo.NashvilleHousing B
on a.ParcelID= b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null
update A
set PropertyAddress = ISNULL(A.PropertyAddress,B.PropertyAddress)
from PortfolioProject1.dbo.NashvilleHousing A
join  PortfolioProject1.dbo.NashvilleHousing B
on a.ParcelID= b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null
--------------------------------------------------------------
-- Breaking out Address into Individual Columns(Address, City, State)
Select  PropertyAddress
From PortfolioProject1.dbo.NashvilleHousing
Select
substring(PropertyAddress, 1, charindex(',', PropertyAddress)-1) as Address
,substring(PropertyAddress, charindex(',', PropertyAddress) +1, len(propertyAddress)) as Address ,

charindex(',',PropertyAddress)

From PortfolioProject1.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PrpertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PrpertySplitAddress = substring(PropertyAddress, 1, charindex(',', PropertyAddress)-1)

-- If it doesn't Update properly

ALTER TABLE NashvilleHousing
Add PropertySplitCity nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = substring(PropertyAddress, charindex(',', PropertyAddress) +1, len(propertyAddress))

Select  *
From PortfolioProject1.dbo.NashvilleHousing

select OwnerAddress
from PortfolioProject1.dbo.NashvilleHousing

select 
PARSENAME(replace(OwnerAddress, ',' , '.'),3),
PARSENAME(replace(OwnerAddress, ',' , '.'),2),
PARSENAME(replace(OwnerAddress, ',' , '.'),1)
from PortfolioProject1.dbo.NashvilleHousing
 ALTER TABLE NashvilleHousing
Add  OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(replace(OwnerAddress, ',' , '.'),3)
-- If it doesn't Update properly

ALTER TABLE NashvilleHousing
Add OwnerSplitCity nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(replace(OwnerAddress, ',' , '.'),2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(replace(OwnerAddress, ',' , '.'),1)

--------------------------------------------------------------
--CHANGE Y and N to Yes and no in "sold as vacant"  filed
select  distinct(soldasvacant),COUNT(soldasvacant)
from Portfolioproject1.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2

select  distinct(soldasvacant),COUNT(soldasvacant)
from Portfolioproject1.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2
select soldasvacant,
case when  soldasvacant = 'Y' then 'Yes'
     when soldasvacant = 'N' then 'No'
	 else soldasvacant
	 end

from Portfolioproject1.dbo.NashvilleHousing
--Group by SoldAsVacant
--order by 2

update  Portfolioproject1.dbo.NashvilleHousing
set SoldAsVacant = case when  soldasvacant = 'Y' then 'Yes'
     when soldasvacant = 'N' then 'No'
	 else soldasvacant
	 end
--------------------------------------------------------------------------
--remove duplicates

Select *
From PortfolioProject1.dbo.NashvilleHousing